#-*- coding: utf-8 -*-#
class Blackjack < Game

  # Game methods
  # Perform the dealer moves
  def dealer_move
    if dealer_needs_to_play?
      value, hard = dealer_hand.value({:points_and_soft => true})
      while (value == 17 && dealer_hand.soft?) || value < 17
        # dealer_hand is less than 17 or is a soft 17
        dealer_hand.cards << draw
        value, hard = dealer_hand.value({:points_and_soft => true})
      end
      dealer_hand.save!
    end
    dealer_hand.mark_as_played
  end

  # Advance to the next player and perform the dealer moves if necessary
  def to_next_player
    self.current_player_idx += 1
    self.save!
    if self.current_player_idx == players.count
      dealer_move
    else
      check_for_blackjack
      dealer_move if dealer_move?
    end
  end

  # Recursively check game for blackjacks for all players:
  #   1) if current player's current hand is a blackjack, then mark it as played
  #   and advance to the next player
  #   2) then if it's the dealer's move, perform the dealer's move, otherwise check
  #   the next player for blackjack
  def check_for_blackjack
    puts 'checking for blackjack' if Rails.env.development?
    if current_player && current_player.current_hand && current_player.current_hand.blackjack?
      current_player.current_hand.mark_as_played
      current_player.end_turn? ? to_next_player : current_player.to_next_hand
      if dealer_move?
        dealer_move
      else
        check_for_blackjack
      end
    end
  end

  def hit(player)
    @card = draw
    @hand = player.current_hand
    @hand.cards << @card
    @hand.save

    if @hand.bust? || @hand.value == 21
      advance_player_or_hand(player)
    end
    check_for_blackjack
  end

  def stand(player)
    @hand = player.current_hand
    @hand.mark_as_played

    advance_player_or_hand(player)
    check_for_blackjack
  end

  def double(player)
    @hand = player.current_hand
    @card = draw
    @hand.cards << @card
    @hand.save
    @hand.mark_as_played

    advance_player_or_hand(player)
    check_for_blackjack
  end

  def split(player)
    @hand = player.current_hand
    if @hand.can_split?
      player.split_hand
    end
    check_for_blackjack
  end

  # Check if player's turn is over and advance to the next player if so, otherwise
  # just advance to the player's next hand
  def advance_player_or_hand(player)
    if player.end_turn?
      player.current_hand.mark_as_played
      to_next_player
    else
      player.to_next_hand
    end
  end

  # Pre-game methods
  # Pre- and post-game actions to prep a game for first time play or between plays
  def reset_game(options = {})
    start_time = Time.now if Rails.env.development?
    # TODO-start - conditional reset, need to check # of remaining cards vs # of players
    set_up_cards if cards.count <= 6 * num_players # create cards and deck(s)
    # shuffle # shuffle cards -- already done by set_up_cards
    # TODO-end
    reset_current_player # start with the right player
    players.each do |p|
      p.reset_current_hand # start with the right hand
    end
    get_new_hands(should_save_hands?) # deal new cards
    deal_cards(options)
    update_attribute(:should_save_hands, true) # after the first deal, always save hands
    check_for_blackjack
    puts "reset_game took #{Time.now - start_time} seconds" if Rails.env.development?
  end

  def reset_current_player
    update_attribute(:current_player_idx, 0)
  end

  # Start card-related methods -------------------------------------------------
  def deal_cards(options = {})
    puts 'deal_cards' if Rails.env.development?
    if should_deal?
      all_hands = players.map(&:current_hand) + [dealer_hand]
      cards = draw((num_players + 1) * 2)
      cards.each_with_index do |card, idx|
        all_hands[(idx % (num_players+1))].cards << card
      end

      if options[:rig_blackjack]
        all_hands.first.cards = Hand.get_blackjack_hand
      elsif options[:rig_split]
        all_hands.first.cards = Hand.get_split_hand
      end

      all_hands.map(&:save!)
    end
  end
  # End card-related methods ---------------------------------------------------

  # Helper methods
  # Check if the dealer needs to play at all
  def dealer_needs_to_play?
    player_hands = []
    players.each do |p|
      p.hands.each do |h|
        player_hands << h.bust? || h.blackjack?
      end
    end
    !player_hands.all?
  end

  # Check if it's the dealer's move
  def dealer_move?
    current_player_idx == players.count
  end

  # Check if the current game is done
  def game_played?
    game_hands = dealer_hand ? [dealer_hand.played] : [nil]
    players.each do |p|
      p.hands.each do |h|
        game_hands << h.played unless h.nil?
      end
    end
    game_hands.all?
  end

  # Draw X number of cards from the deck
  def draw(n = 1)
    if n == 1
      card = Card.find(cards.pop.to_i)
      save!
      return card
    else
      popped = []
      n.times do
        popped << Card.find(cards.pop.to_i)
      end
      save!
      return popped
    end
  end

  def all_cards
    cards.map(&:to_s)
  end

  def cards_left
    cards.count
  end

  def to_s
    puts "Blackjack ##{id}"
    puts "\tDealer hand: #{dealer_hand.to_s}"
    puts "\tPlayer hands:"
    players.each_with_index do |p, p_i|
      puts "\t\tPlayer ##{p_i+1}:"
      p.hands.each_with_index do |h, h_i|
        puts "\t\t\tHand ##{h_i+1}: #{h.to_s}"
      end
    end
  end

  def current_player
    if current_player_idx == players.count
      return nil
    else
      return players[current_player_idx]
    end
  end

  def current_player_id
    if current_player.nil?
      return -1
    else
      return current_player.id
    end
  end

  def current_hand_idx_if
    if current_player.nil?
      return -1
    else
      return current_player.current_hand_idx
    end
  end

  def current_hand_id_if
    if current_player.nil?
      return -1
    else
      return current_player.current_hand_id
    end
  end

  def to_firebase_hash
    return {
      :blackjack_id => id,
      :dealer => dealer_hand ? dealer_hand.to_firebase_hash(:dealer => dealer_move?) : {},
      :current_player_idx => current_player_idx,
      :current_player_id => current_player_id,
      :current_hand_idx => current_hand_idx_if,
      :current_hand_id => current_hand_id_if,
      :players => players.map(&:to_firebase_hash),
      :game_played => game_played?
    }
  end

  # ----- Private ----- #

  private
end
