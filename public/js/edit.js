$(function() {
  var cards = [];
  var currentCard = null;
  var cardListView = $("#card-list tbody");
  var frontField = $("#card-edit input.front");
  var backField = $("#card-edit input.back");

  var renderCardItem = function( card ) {
    return $(
      "<tr><td class=\"front span5\">" + card.front + "</td>" +
      "<td class=\"back span5\">"  + card.back  + "</td></tr>"
    ).data("card",card);
  };

  var addCardToList = function(card,prepend) {
    var content = renderCardItem(card);
    if (prepend)
      cardListView.prepend(content);
    else
      cardListView.append(content);
    return content;
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
  var resetEditedCard = function(e) {
    initNewCard();
    e.preventDefault();
  };

  $("#card-list").on("click", "tr", onCardItemClicked );
  $("#ok").on("click", saveEditedCard );
  $("#cancel").on("click", resetEditedCard );

  $.get("/cards", receiveCards);
});


