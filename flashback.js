$(function() {
  var cards = [
    { front: "foo", back: "FOO" },
    { front: "bar", back: "BAR" },
    { front: "baz", back: "BAZ" },
    { front: "qux", back: "QUX" },
  ];
  var cardIndex = 0;
  var cardView = $(".card");
  var frontView = cardView.find(".front");
  var backView = cardView.find(".back");

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
    }
  };

  var reschedule = function(when) {
    var offset = ((when==="soon") ? "-" : "+") + cardView.outerHeight();
    cardView.animate({top: offset, opacity: 0}, nextCard);
  };
  var cardUp = function() {
    if (cardView.hasClass("flipped")) {
      reschedule("soon");
    }
    cardView.toggleClass("flipped");
  };
  var cardDown = function() {
    if (cardView.hasClass("flipped")) {
      reschedule("later");
    }
    cardView.toggleClass("flipped");
  };
  var cardRight = function() {
  };
  var cardLeft = function() {
  };

  $("body").on( "keydown", function(e) {
    switch(e.keyCode) {
      case 38: cardUp(); break;
      case 40: cardDown(); break;
      case 39: cardRight(); break;
      case 37: cardLeft(); break;
    }
  });

  refreshCardView();
});
