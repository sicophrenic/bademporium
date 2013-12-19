#-*- coding: utf-8 -*-#
module FirebaseHelper
  def firebase_ref
    FIREBASE
  end

  def push_blackjack_to_firebase(game)
    puts 'attempting to update game ' + game.id.to_s
    FIREBASE.update("blackjack_#{game.id}", game.to_firebase_hash)
  end

  def remove_blackjack_from_firebase(game)
    puts 'attempting to delete game ' + game.id.to_s
    FIREBASE.delete("blackjack_#{game.id}")
  end
end