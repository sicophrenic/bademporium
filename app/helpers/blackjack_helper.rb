#-*- coding: utf-8 -*-#
module BlackjackHelper
  def include_firebase
    load_firebase
    link_firebase
    init_firebase
  end

  def show_or_hide_hit_button
    javascript_tag "
      var show_or_hide_hit_button = function(idx_of) {
        if (idx_of >= 0) {
          $('.hit-btn').show();
        } else {
          $('.redeal-btn').hide();
        }
      }
      show_or_hide_hit_button(false);
    "
  end
  def show_or_hide_stand_button
    javascript_tag "
      var show_or_hide_stand_button = function(idx_of) {
        if (idx_of >= 0) {
          $('.stand-btn').show();
        } else {
          $('.stand-btn').hide();
        }
      }
      show_or_hide_stand_button(false);
    "
  end
  def show_or_hide_double_button
    javascript_tag "
      var show_or_hide_double_button = function(idx_of) {
        if (idx_of >= 0) {
          $('.double-btn').show();
        } else {
          $('.double-btn').hide();
        }
      }
      show_or_hide_double_button(false);
    "
  end
  def show_or_hide_split_button
    javascript_tag "
      var show_or_hide_split_button = function(idx_of) {
        if (idx_of >= 0) {
          $('.split-btn').show();
        } else {
          $('.split-btn').hide();
        }
      }
      show_or_hide_split_button(false);
    "
  end
  def show_or_hide_redeal_button
    javascript_tag "
      var show_or_hide_redeal_button = function(game_over) {
        if (game_over) {
          $('.redeal-btn').show();
          $('.hit-btn').hide();
          $('.stand-btn').hide();
          $('.split-btn').hide();
          $('.double-btn').hide();
        } else {
          $('.redeal-btn').hide();
        }
      }
      show_or_hide_redeal_button(false);
    "
  end

  def show_or_hide_admin_buttons
  end

  def firebase_update_dealer
    javascript_tag "
      var update_dealer_hand = function(dealer_hand) {
        if (dealer_hand != undefined) {
          var dealer_hand_div = $(\"#dealer_hand\");
          dealer_hand_div.text(\"Dealer hand\");
          dealer_hand_div.append(\"<br/>\");
          dealer_hand.cards.forEach(function(c) {
            dealer_hand_div.append(\"<img alt=\" + c + \" src=\" + c + \"/>\");
          });
        }
      }
    "
  end

  def firebase_update_winners
    javascript_tag "
      var update_winners = function(players) {
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
      var update_player_hands = function(players, curr_hand_id) {
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
                      hand_div.append(\"<img alt=\" + c + \" src=\" + c + \"/>\");
                    });
                    hand_count++;

                    if (h.hand_id == curr_hand_id) {
                      show_or_hide_hit_button($.inArray('hit', h.actions));
                      show_or_hide_stand_button($.inArray('stand', h.actions));
                      show_or_hide_double_button($.inArray('double', h.actions));
                      show_or_hide_split_button($.inArray('split', h.actions));
                    }
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
      var update_hands = function(game) {
        if (game.blackjack_id == #{@blackjack.id}) {
          update_dealer_hand(game.dealer);
          update_player_hands(game.players, game.current_hand_id);
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
        game = snapshot.val();
        update_hands(game);
        show_or_hide_redeal_button(game.game_played);
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
