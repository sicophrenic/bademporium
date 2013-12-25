#-*- coding: utf-8 -*-#
module BlackjackHelper
  def include_firebase
    load_firebase
    link_firebase
    init_firebase
  end

  def firebase_update_dealer
    javascript_tag "
      var update_dealer_hand = function(dealer_hand) {
        if (dealer_hand != undefined) {
          $(\"#dealer_hand\").text(dealer_hand.cards);
        }
      }
    "
  end

  def firebase_update_players
    # TODO - add additional details to Firebase to prevent eager-loading here
    javascript_tag "
      var update_player_hands = function(players) {
        if (players != undefined) {
          players.forEach(function(p) {
            if (p != undefined) {
              player_ref = \"#player_\" + p.id;
              player_div = $(player_ref);
              hand_count = 0;
              if (p.hands != undefined) {
                p.hands.forEach(function(h) {
                  if (h != undefined) {
                    hand_ref = player_ref + \"_hand_\" + hand_count;
                    player_div.append(\"<div id=\" + hand_ref + \">\" + h.cards + \"</div>\");
                    hand_count++;
                  }
                });
              }
            }
          });
        }
      }
    "
  end

  def firebase_update_hands
    javascript_tag "
      var update_hands = function(snapshot) {
        game = snapshot.val();
        #{"alert(game.blackjack_id);" if Rails.env.development?}
        if (game.blackjack_id == #{@blackjack.id}) {
          update_dealer_hand(game.dealer);
          update_player_hands(game.players);
        }
      }
    "
  end

  def load_firebase
    javascript_tag "
      bademporium.on('value', function(snapshot) {
        console.log('new value!');
        update_hands(snapshot);
        console.log('go!');
      });
    "
  end

  def link_firebase
    javascript_tag "
      var bademporium = new Firebase('#{FIREBASE_URL}blackjack_#{@blackjack.id}');
    "
  end

  def init_firebase
    javascript_tag "

    "
  end
end

# example:
# $.getScript('https://cdn.firebase.com/v0/firebase.js');
# var bademporium = new Firebase('https://bademporium-dev.firebaseio.com/blackjack_27');
# bademporium.on('value', function (snapshot) { console.log('hello'); window.snap = snapshot; });
