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
    offset = ((if (state is "retained") then "-" else "+")) + cardView.outerHeight()
    cardView.animate
      top: offset
      opacity: 0
    , nextCard
    $.post "/card/" + card().id + "/" + state

  cardUp = ->
    reschedule "retained"  if cardView.hasClass("flipped")
    cardView.toggleClass "flipped"

  cardDown = ->
    reschedule "forgotten"  if cardView.hasClass("flipped")
    cardView.toggleClass "flipped"

  $("body").on "keydown", (e) ->
    if cardView.css("opacity") is 1
      switch e.which
        when 38
          cardUp()
        when 40
          cardDown()
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
