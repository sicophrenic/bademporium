#-*- coding: utf-8 -*-#
module FirebaseHelper
  def firebase_ref
    FIREBASE
  end

  def firebase_path(game)
    if Rails.env.staging?
      "blackjack_staging_#{game.id}"
    else
      "blackjack_#{game.id}"
    end
  end

  def push_blackjack_to_firebase(game)
    puts 'attempting to update game ' + game.id.to_s
    FIREBASE.update(firebase_path(game), game.to_firebase_hash)
  end

  def remove_blackjack_from_firebase(game)
    puts 'attempting to delete game ' + game.id.to_s
    FIREBASE.delete(firebase_path(game))
  end
end