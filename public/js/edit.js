$(function() {
  var cards = [];
  var currentCard = null;
  var cardListView = $("#card-list tbody");
  var frontField = $("#card-edit input.front");
  var backField = $("#card-edit input.back");

  var renderCardItem = function( card ) {
    return $(
      "<tr><td class=\"front\">" + card.front + "</td>" +
      "<td class=\"back\">"  + card.back  + "</td>" +
      "<td class=\"span2\"><button class=\"remove btn btn-danger btn-small\">&times;</button></td>" +
      "</tr>"
    ).data("card",card);
  };

  var addCardToList = function(card,prepend) {
    var content = renderCardItem(card);
    return prepend ? content.prependTo(cardListView) : content.appendTo(cardListView);
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
    return $(".success", cardListView);
  };

  var onCardItemClicked = function() {
    var node = $(this).closest('tr');
    var nodeCard = node.data("card");
    if (nodeCard) {
      currentCardItem().removeClass("success");
      node.addClass("success");
      setCurrentCard( nodeCard );
      $("#ok").text("update");
    }
  };

  var initNewCard = function() {
    currentCardItem().removeClass("success");
    $("#ok").text("add");
    setCurrentCard( { front: "", back: "" } );
  };

  var cardUpdater = function( card, view ) {
    return function( data ) {
      card.id = data.id;
      view.removeClass("warning");
    };
  }

  var saveEditedCard = function(e) {
    e.preventDefault();

    currentCard.front = frontField.val();
    currentCard.back = backField.val();

    var el = currentCardItem();
    if (el.length) {
      el.replaceWith( el = renderCardItem( currentCard ) );
    } else {
      el = addCardToList( currentCard, true );
    }

    var updater = cardUpdater( currentCard, el );
    el.addClass("warning");

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

  var removeCard = function(card) {
    $.ajax({url: "/card/" + card.id, type: "DELETE"});
  }

  var animateRowRemoval = function(row) {
    row.animate({opacity: 0},function(){
      var placeholder = $("<div></div>");
      placeholder.height( row.height() );
      row.html( placeholder );
      placeholder.animate({height:0},function(){row.remove()});
    });
  };

  var onRemoveClicked = function(e) {
    var node = $(this).closest('tr');
    var nodeCard = node.data("card");
    if (nodeCard) {
      removeCard(nodeCard);
    }
    animateRowRemoval( node );
  }

  $("#card-list").on("click", "button", function(e){e.stopPropagation();});
  $("#card-list").on("click", "button.remove", onRemoveClicked);
  $("#card-list").on("click", "td", onCardItemClicked );

  $("#ok").on("click", saveEditedCard );
  $("#cancel").on("click", resetEditedCard );

  $.get("/cards", receiveCards);
});


