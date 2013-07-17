//
$(function() {
  var card = $(".card");

  var nextCard = function() {
    card.css("top",0);
    card.css("left", - card.outerWidth());
    card.animate({left: 0, opacity: 1.0});
  };

  var reschedule = function(when) {
    var offset = ((when==="soon") ? "-" : "+") + card.outerHeight();
    card.animate({top: offset, opacity: 0}, nextCard);
  };
  var cardUp = function() {
    if (card.hasClass("flipped")) {
      reschedule("soon");
    }
    card.toggleClass("flipped");
  };
  var cardDown = function() {
    if (card.hasClass("flipped")) {
      reschedule("later");
    }
    card.toggleClass("flipped");
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
});
