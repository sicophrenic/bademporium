#-*- coding: utf-8 -*-#
if Rails.env.development?
  firebase_url = 'https://bademporium-dev.firebaseio.com/'
else
  firebase_url = 'https://bademporium.firebaseio.com/'
end

FIREBASE = Firebase.new(firebase_url)