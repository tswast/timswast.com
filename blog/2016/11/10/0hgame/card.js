
var aiPlayer = {
  score: 0,
  cards: [],
  chat: '',
  state: 'waiting',
  passingCards: [],
  desiredRank: 0,
  grabCallback: function() {
    setTimeout(aiGrabCards, randomDelay())
  },
  fishCallback: function() {
    setTimeout(aiGoFish, randomDelay())
  },
};
var humanPlayer = {
  score: 0,
  cards: [],
  chat: '',
  state: 'playing',
  passingCards: [],
  desiredRank: 0,
  grabCallback: function() {},
  fishCallback: function() {},
};
var ocean = [];

// Unicode values of the different cards.
// See: http://en.wikipedia.org/wiki/Playing_cards_in_Unicode
var cards = {
    '🂡': {suit: '♠', rank: 1},
    '🂱': {suit: '♥', rank: 1},
    '🃁': {suit: '♦', rank: 1},
    '🃑': {suit: '♣', rank: 1},
    '🂢': {suit: '♠', rank: 2},
    '🂲': {suit: '♥', rank: 2},
    '🃂': {suit: '♦', rank: 2},
    '🃒': {suit: '♣', rank: 2},
    '🂣': {suit: '♠', rank: 3},
    '🂳': {suit: '♥', rank: 3},
    '🃃': {suit: '♦', rank: 3},
    '🃓': {suit: '♣', rank: 3},
    '🂤': {suit: '♠', rank: 4},
    '🂴': {suit: '♥', rank: 4},
    '🃄': {suit: '♦', rank: 4},
    '🃔': {suit: '♣', rank: 4},
    '🂥': {suit: '♠', rank: 5},
    '🂵': {suit: '♥', rank: 5},
    '🃅': {suit: '♦', rank: 5},
    '🃕': {suit: '♣', rank: 5},
    '🂦': {suit: '♠', rank: 6},
    '🂶': {suit: '♥', rank: 6},
    '🃆': {suit: '♦', rank: 6},
    '🃖': {suit: '♣', rank: 6},
    '🂧': {suit: '♠', rank: 7},
    '🂷': {suit: '♥', rank: 7},
    '🃇': {suit: '♦', rank: 7},
    '🃗': {suit: '♣', rank: 7},
    '🂨': {suit: '♠', rank: 8},
    '🂸': {suit: '♥', rank: 8},
    '🃈': {suit: '♦', rank: 8},
    '🃘': {suit: '♣', rank: 8},
    '🂩': {suit: '♠', rank: 9},
    '🂹': {suit: '♥', rank: 9},
    '🃉': {suit: '♦', rank: 9},
    '🃙': {suit: '♣', rank: 9},
    '🂪': {suit: '♠', rank: 10},
    '🂺': {suit: '♥', rank: 10},
    '🃊': {suit: '♦', rank: 10},
    '🃚': {suit: '♣', rank: 10},
    '🂫': {suit: '♠', rank: 11},
    '🂻': {suit: '♥', rank: 11},
    '🃋': {suit: '♦', rank: 11},
    '🃛': {suit: '♣', rank: 11},
    '🂭': {suit: '♠', rank: 12},
    '🂽': {suit: '♥', rank: 12},
    '🃍': {suit: '♦', rank: 12},
    '🃝': {suit: '♣', rank: 12},
    '🂮': {suit: '♠', rank: 13},
    '🂾': {suit: '♥', rank: 13},
    '🃎': {suit: '♦', rank: 13},
    '🃞': {suit: '♣', rank: 13},

    // JOKER: '🃟',
}

function draw () {
  var cardIndex = Math.floor(Math.random() * ocean.length)
  var card = ocean[cardIndex]
  ocean.splice(cardIndex, 1)
  return card
}

function deal (player, numCards) {
  // Select random cards from the ocean and put them in the player's hand.
  for (i = 0; i < numCards && ocean.length > 0; i++) {
    var card = draw();
    player.cards.push(card);
  }
}

function checkForMatches (player) {
  var ranks = {}
  for (i = 0; i < player.cards.length; i++) {
    var card = player.cards[i]
    var rank = cards[card].rank
    if (ranks[rank] === undefined) {
      ranks[rank] = []
    }
    ranks[rank].push(i)
  }
  
  for (var rank in ranks) {
    if (ranks[rank].length == 4) {
      // Score!
      player.score++
      
      while (ranks[rank].length > 0) {
        // Indexes should be in sorted order,
        // since they were added by looping in order.
        var cardToDelete = ranks[rank].pop()
        player.cards.splice(cardToDelete, 1)
      }
    }
  }
}

function finishAiTurn () {
  humanPlayer.state = 'playing'
  humanPlayer.chat = ''
  aiPlayer.state = 'waiting'
  aiPlayer.chat = ''
  checkForMatches(aiPlayer)
  playHuman()
}

function finishHumanTurn() {
  humanPlayer.state = 'waiting'
  humanPlayer.chat = ''
  aiPlayer.state = 'playing'
  aiPlayer.chat = ''
  checkForMatches(humanPlayer)
  setTimeout(playAi, randomDelay())
}

function aiGrabCards() {
  aiPlayer.cards = aiPlayer.cards.concat(humanPlayer.passingCards)
  humanPlayer.passingCards = []
  finishAiTurn()
  render()
}

function grabCards() {
  humanPlayer.cards = humanPlayer.cards.concat(aiPlayer.passingCards)
  aiPlayer.passingCards = []
  finishHumanTurn()
  render()
}

function respondToCard(responder, receiver) {
  var rank = receiver.desiredRank
  for (var i = 0; i < responder.cards.length; i++) {
    var loopCard = responder.cards[i];
    if (cards[loopCard].rank === rank) {
      responder.passingCards.push(loopCard)
      responder.cards.splice(i, 1)
      i--
    }
  }

  if (responder.passingCards.length != 0) {
    responder.chat = '👍'
    receiver.state = 'grabbing'
    receiver.grabCallback()
  } else {
    responder.chat = '🐟 !'
    receiver.state = 'fishing'
    receiver.fishCallback()
  }
  render()
}

function randomDelay() {
  return Math.random() * 500 + 500;
}

function askForCard(card) {
  humanPlayer.chat = card + '?'
  humanPlayer.state = 'asking'
  humanPlayer.desiredRank = cards[card].rank
  render()
  setTimeout(function() {respondToCard(aiPlayer, humanPlayer)}, randomDelay())
}

function aiChooseCardToAsk() {
  // TODO: be smarter and remember some of what the human has.
  return aiPlayer.cards[Math.floor(Math.random() * aiPlayer.cards.length)]
}

function drawIfEmpty(player) {
  if (player.cards.length == 0) {
    deal(player, 5)
  }
}

function playHuman() {
  drawIfEmpty(humanPlayer)
}

function playAi() {
  drawIfEmpty(aiPlayer)
  var card = aiChooseCardToAsk()
  aiPlayer.chat = card + ' ?'
  aiPlayer.state = 'asking'
  aiPlayer.desiredRank = cards[card].rank
  humanPlayer.state = 'asked'
  render()
  setTimeout(function() {respondToCard(humanPlayer, aiPlayer)}, randomDelay())
}

function aiGoFish() {
  deal(aiPlayer, 1)
  finishAiTurn()
  render()
}

function goFish() {
  deal(humanPlayer, 1)
  finishHumanTurn()
  render()
}

function render () {
  document.getElementById('playerScores').textContent = (
      aiPlayer.score + ' 🤖 ' + humanPlayer.score + ' ⭐️')

  document.getElementById('aiPlayerChat').textContent = aiPlayer.chat || '\u00A0'
  
  var aiPlayerGrab = document.getElementById('aiPlayerGrab')
  aiPlayerGrab.textContent = '\u00A0'
  if (aiPlayer.passingCards.length != 0) {
    aiPlayerGrab.innerHTML = ('<a href="#" onclick="grabCards();return false;">' +
        aiPlayer.passingCards.join(' ') + '</a>')
  }

  var aiHandRender = ''
  for (var i = 0; i < aiPlayer.cards.length; i++) {
    aiHandRender = aiHandRender + '🂠 '
  }
  document.getElementById('aiPlayerHand').textContent = aiHandRender

  var oceanRender = ocean.length + ' 🐟'
  if (humanPlayer.state === 'fishing') {
    oceanRender = '<a href="#" onclick="goFish();return false;">' + oceanRender + '</a>'
  }
  document.getElementById('ocean').innerHTML = oceanRender
  
  var humanPlayerGrab = document.getElementById('humanPlayerGrab')
  humanPlayerGrab.textContent = '\u00A0'
  if (humanPlayer.passingCards.length != 0) {
    humanPlayerGrab.textContent = humanPlayer.passingCards.join(' ')
  }

  document.getElementById('humanPlayerChat').textContent = humanPlayer.chat || '\u00A0'

  humanPlayer.cards.sort(
    function (a, b) {
      return cards[a].rank - cards[b].rank
     })

  var humanHandRender = humanPlayer.cards.join(' ');
  if (humanPlayer.state === 'playing') {
    humanHandRender = '';
    for (var i = 0; i < humanPlayer.cards.length; i++) {
      var card = humanPlayer.cards[i]
      var cardLink = (
          '<a href="#" onclick="askForCard('
          + "'"
          + card
          + "'"
          + ');return false;">'
          + card
          + '</a> ');
      humanHandRender = humanHandRender + cardLink;
    }
  }
  document.getElementById('humanPlayerHand').innerHTML = humanHandRender;
}

function init() {
  ocean = Object.keys(cards);
  deal(humanPlayer, 5);
  deal(aiPlayer, 5);

  render()
}

window.addEventListener("DOMContentLoaded", init);
if (document.readyState !== "loading") {
  init()
}
