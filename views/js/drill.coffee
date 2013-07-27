$ ->
  cards = []
  cardIndex = 0
  cardView = $(".card")
  frontView = cardView.find(".front")
  backView = cardView.find(".back")
  againButton = $("#againButton")
  endModal = $("#endModal")
  noCardsModal = $("#noCardsModal")

  card = ->
    cards[cardIndex]

  refreshCardView = ->
    frontView.text card().front
    backView.text card().back
    cardView.removeClass "hide"
    cardView.css "top", 0
    cardView.css "left", -cardView.outerWidth()
    cardView.animate
      left: 0
      opacity: 1.0

  nextCard = ->
    cardIndex++
    if cardIndex < cards.length
      refreshCardView()
    else
      endModal.modal()

  reschedule = (state) ->
    sign = if state is "retained" then "-" else "+"
    offset = "#{sign}#{cardView.outerHeight()}"
    cardView.animate
      top: offset
      opacity: 0
    , nextCard
    $.post "/card/" + card().id + "/" + state

  flipCard = (state) ->
    reschedule(state) if cardView.hasClass("flipped")
    cardView.toggleClass "flipped"

  $("body").on "keydown", (e) ->
    if parseFloat(cardView.css("opacity")) == 1
      switch e.which
        when 38
          flipCard "retained"
        when 40
          flipCard "forgotten"
    true

  receiveCards = (json) ->
    cards = json
    if cards.length
      cardIndex = 0
      refreshCardView()
    else
      noCardsModal.modal()

  reloadLesson = ->
    $.get "/cards/scheduled", receiveCards

  endModal.on "hidden", reloadLesson
  reloadLesson()
