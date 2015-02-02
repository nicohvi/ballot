## third-party libs
#= require jquery
#= require jquery_ujs
#= require jquery.tipsy
#= require jquery.validate
#= require chartjs.min
#= require bacon
#= require lodash
#= require headroom
#= require jquery.headroom
#= require jvfloat

##
#= require_tree ./lib
#= require header
#= require flash
#= require user

$ ->
  $('i').tipsy { gravity: 'n' }
  $('header').headroom()
