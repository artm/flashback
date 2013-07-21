$(function() {
  var cards = [ ];
  var cardIndex = 0;
  var cardView = $(".card");
  var frontView = cardView.find(".front");
  var backView = cardView.find(".back");
  var againButton = $("#againButton");
  var endModal = $("#endModal");
  var noCardsModal = $("#noCardsModal");

  var card = function() { return cards[cardIndex]; }

  var refreshCardView = function() {
    frontView.text( card().front );
    backView.text( card().back );
    cardView.css("top",0);
    cardView.css("left", - cardView.outerWidth());
    cardView.animate({left: 0, opacity: 1.0});
  }

  var nextCard = function() {
    cardIndex++;
    if (cardIndex < cards.length) {
      refreshCardView();
    } else {
      endModal.modal();
    }
  };

  var reschedule = function(state) {
    var offset = ((state==="retained") ? "-" : "+") + cardView.outerHeight();
    cardView.animate({top: offset, opacity: 0}, nextCard);
    $.post("/card/" + card().id + "/" + state);
  };
  var cardUp = function() {
    if (cardView.hasClass("flipped")) {
      reschedule("retained");
    }
    cardView.toggleClass("flipped");
  };
  var cardDown = function() {
    if (cardView.hasClass("flipped")) {
      reschedule("forgotten");
    }
    cardView.toggleClass("flipped");
  };

  $("body").on( "keydown", function(e) {
    if (cardView.css("display") == "block" && cardView.css("opacity") == 1) {
      switch(e.keyCode) {
        case 38: cardUp(); break;
        case 40: cardDown(); break;
      }
    }
  });

  var receiveCards = function(json) {
    cards = json;
    if (cards.length) {
      cardIndex = 0;
      refreshCardView();
    } else
      noCardsModal.modal();
  }

  var reloadLesson = function() {
    $.get('/cards/scheduled',receiveCards);
  };

  endModal.on("hidden", reloadLesson);
  reloadLesson();
});
