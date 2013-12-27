#-*- coding: utf-8 -*-#
module BlackjackHelper
  def include_firebase
    load_firebase
    link_firebase
    init_firebase
  end

  def show_or_hide_hit_button
  end
  def show_or_hide_stand_button
  end
  def show_or_hide_double_button
  end
  def show_or_hide_split_button
  end
  def show_or_hide_redeal_button
  end

  def show_or_hide_admin_buttons
  end

  def firebase_update_dealer
    javascript_tag "
      console.log('updating dealer');
      var update_dealer_hand = function(dealer_hand) {
        if (dealer_hand != undefined) {
          var dealer_hand_div = $(\"#dealer_hand\");
          dealer_hand_div.text(\"Dealer hand\");
          dealer_hand_div.append(\"<br/>\");
          dealer_hand.cards.forEach(function(c) {
            dealer_hand_div.append(\"<img src=\" + c + \"/>\");
          });
        }
      }
    "
  end

  def firebase_update_winners
    javascript_tag "
      var update_winners = function(players) {
        console.log('updating winners');
        players.forEach(function(p) {
          if (p != undefined) {
            player_ref = \"player_\" + p.player_id;
            player_div = $(\"#\" + player_ref);
            hand_count = 0;
            if (p.hands != undefined) {
              p.hands.forEach(function(h) {
                if (h != undefined) {
                  hand_ref = player_ref + \"_hand_\" + hand_count;
                  hand_div = $(\"#\" + hand_ref);
                  if (h.result != undefined) {
                    hand_div.addClass(h.result);
                  }
                }
              });
            }
          }
        });
      }
    "
  end

  def firebase_update_players
    # TODO - add additional details to Firebase to prevent eager-loading here
    javascript_tag "
      console.log('updating players');
      var update_player_hands = function(players) {
        if (players != undefined) {
          players.forEach(function(p) {
            if (p != undefined) {
              player_ref = \"player_\" + p.player_id;
              player_div = $(\"#\" + player_ref);
              player_div.text(\"Player hand\");
              player_div.append(\"<br/>\");
              hand_count = 0;
              if (p.hands != undefined) {
                p.hands.forEach(function(h) {
                  if (h != undefined) {
                    hand_ref = player_ref + \"_hand_\" + hand_count;
                    player_div.append(\"<div id=\" + hand_ref + \"></div>\");
                    hand_div = $(\"#\" + hand_ref);
                    h.cards.forEach(function(c) {
                      hand_div.append(\"<img src=\" + c + \"/>\");
                    });
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
        console.log('updating hands');
        game = snapshot.val();
        if (game.blackjack_id == #{@blackjack.id}) {
          update_dealer_hand(game.dealer);
          update_player_hands(game.players);
          if (game.game_played) {
            update_winners(game.players);
          }
        }
      }
    "
  end

  def load_firebase
    javascript_tag "
      bademporium.on('value', function(snapshot) {
        console.log('value');
        update_hands(snapshot);
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
