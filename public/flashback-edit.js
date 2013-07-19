$(function() {
  var cards = [];
  var currentCard = null;
  var cardListView = $('#card-list');
  var frontField = $('.card .front');
  var backField = $('.card .back');

  var renderCardItem = function( card ) {
    return $(
      "<div class=\"front\">" + card.front + "</div>" +
      "<div class=\"back\">"  + card.back  + "</div>"
    );
  };

  var addCardToList = function(card,prepend) {
    var content = $("<li></li>").html(renderCardItem(card)).data("card", card);
    if (prepend)
      cardListView.prepend(content);
    else
      cardListView.append(content);
  };

  var renderCardList = function() {
    cardListView.empty();
    for(var i=0; i<cards.length; i++) {
      addCardToList(cards[i]);
    }
  };

  var receiveCards = function(_cards) {
    cards = _cards;
    renderCardList();
    initNewCard();
  };

  var setCurrentCard = function( card ) {
    frontField.val( card.front );
    backField.val( card.back );
    currentCard = card;
  };

  var currentCardItem = function() {
    return $(".current", cardListView);
  };

  var onCardItemClicked = function() {
    currentCardItem().removeClass("current");
    var node = $(this)
    node.addClass("current");
    setCurrentCard( node.data("card") );
    $("#ok").text("update");
  };

  var initNewCard = function() {
    currentCardItem().removeClass("current");
    $("#ok").text("add");
    setCurrentCard( { front: "", back: "" } );
  };
  var onOk = function() {
    currentCard.front = frontField.val();
    currentCard.back = backField.val();
    if (currentCardItem().length) {
      currentCardItem().html( renderCardItem( currentCard ) );
    } else {
      addCardToList( currentCard, true );
    }
    initNewCard();
  };
  var onCancel = function() {
    initNewCard();
  };

  $("#card-list").on("click", "li", onCardItemClicked );
  $("#ok").on("click", onOk );
  $("#cancel").on("click", onCancel );

  $.get('/cards', receiveCards);
});


