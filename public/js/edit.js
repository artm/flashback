$(function() {
  var cards = [];
  var currentCard = null;
  var cardListView = $("#card-list");
  var frontField = $("#card-list input.front");
  var backField = $("#card-list input.back");

  var renderCardItem = function( card ) {
    return $(
      "<td class=\"front\">" + card.front + "</td>" +
      "<td class=\"back\">"  + card.back  + "</td>"
    );
  };

  var addCardToList = function(card,prepend) {
    var content = $("<tr></tr>").html(renderCardItem(card)).data("card", card);
    if (prepend)
      cardListView.prepend(content);
    else
      cardListView.append(content);
    return content;
  };

  var renderCardList = function() {
    $("tr:contains(td)",cardListView).remove()
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
    var node = $(this);
    var nodeCard = node.data("card");
    if (nodeCard) {
      currentCardItem().removeClass("current");
      node.addClass("current");
      setCurrentCard( nodeCard );
      $("#ok").text("update");
    }
  };

  var initNewCard = function() {
    currentCardItem().removeClass("current");
    $("#ok").text("add");
    setCurrentCard( { front: "", back: "" } );
  };

  var cardUpdater = function( card, view ) {
    return function( data ) {
      card.id = data.id;
      view.removeClass("updating");
    };
  }

  var saveEditedCard = function() {
    currentCard.front = frontField.val();
    currentCard.back = backField.val();

    var el = currentCardItem();
    if (el.length) {
      el.html( renderCardItem( currentCard ) );
    } else {
      el = addCardToList( currentCard, true );
    }

    var updater = cardUpdater( currentCard, el );
    el.addClass("updating");

    if (currentCard.id) {
      $.post( "/card/" + currentCard.id, currentCard, updater );
    } else {
      $.post( "/card", currentCard, updater );
    }

    initNewCard();
  };
  var resetEditedCard = function() {
    initNewCard();
  };

  $("#card-list").on("click", "tr", onCardItemClicked );
  $("#ok").on("click", saveEditedCard );
  $("#cancel").on("click", resetEditedCard );

  $.get("/cards", receiveCards);
});


