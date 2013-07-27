$ ->
  cards = []
  currentCard = null
  cardListView = $("#card-list tbody")
  frontField = $("#card-edit input.front")
  backField = $("#card-edit input.back")

  renderCardItem = (card) ->
    $("<tr><td class=\"front\">#{card.front}</td>" + "<td class=\"back\">" + card.back + "</td>" + "<td class=\"span2\"><button class=\"remove btn btn-danger btn-small\">&times;</button></td>" + "</tr>").data "card", card

  addCardToList = (card, prepend) ->
    content = renderCardItem(card)
    (if prepend then content.prependTo(cardListView) else content.appendTo(cardListView))

  renderCardList = ->
    cardListView.empty()
    i = 0

    while i < cards.length
      addCardToList cards[i]
      i++

  receiveCards = (_cards) ->
    cards = _cards
    renderCardList()
    initNewCard()

  setCurrentCard = (card) ->
    frontField.val card.front
    backField.val card.back
    currentCard = card

  currentCardItem = ->
    $ ".success", cardListView

  onCardItemClicked = ->
    node = $(this).closest("tr")
    nodeCard = node.data("card")
    if nodeCard
      currentCardItem().removeClass "success"
      node.addClass "success"
      setCurrentCard nodeCard
      $("#ok").text "update"

  initNewCard = ->
    currentCardItem().removeClass "success"
    $("#ok").text "add"
    setCurrentCard
      front: ""
      back: ""


  cardUpdater = (card, view) ->
    (data) ->
      card.id = data.id
      view.removeClass "warning"

  saveEditedCard = (e) ->
    e.preventDefault()
    currentCard.front = frontField.val()
    currentCard.back = backField.val()
    el = currentCardItem()
    if el.length
      el.replaceWith el = renderCardItem(currentCard)
    else
      el = addCardToList(currentCard, true)
    updater = cardUpdater(currentCard, el)
    el.addClass "warning"
    if currentCard.id
      $.post "/card/" + currentCard.id, currentCard, updater
    else
      $.post "/card", currentCard, updater
    initNewCard()

  resetEditedCard = (e) ->
    initNewCard()
    e.preventDefault()

  removeCard = (card) ->
    $.ajax
      url: "/card/" + card.id
      type: "DELETE"


  animateRowRemoval = (row) ->
    row.animate
      opacity: 0
    , ->
      placeholder = $("<div></div>")
      placeholder.height row.height()
      row.html placeholder
      placeholder.animate
        height: 0
      , ->
        row.remove()



  onRemoveClicked = (e) ->
    node = $(this).closest("tr")
    nodeCard = node.data("card")
    removeCard nodeCard  if nodeCard
    animateRowRemoval node

  $("#card-list").on "click", "button", (e) ->
    e.stopPropagation()

  $("#card-list").on "click", "button.remove", onRemoveClicked
  $("#card-list").on "click", "td", onCardItemClicked
  $("#ok").on "click", saveEditedCard
  $("#cancel").on "click", resetEditedCard
  $.get "/cards", receiveCards
