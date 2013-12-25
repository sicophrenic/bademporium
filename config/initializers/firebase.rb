#-*- coding: utf-8 -*-#
FIREBASE_URL =
  Rails.env.development? ?
    'https://bademporium-dev.firebaseio.com/' :
    'https://bademporium.firebaseio.com/'

FIREBASE = Firebase.new(FIREBASE_URL)