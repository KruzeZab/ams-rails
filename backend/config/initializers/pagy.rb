require 'pagy/extras/limit'
require 'pagy/extras/headers'
require 'pagy/extras/metadata'
require 'pagy/extras/overflow'

Pagy::DEFAULT[:limit] = 10
Pagy::DEFAULT[:limit_max] = 20