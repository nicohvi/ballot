#= require jquery
#= require jquery_ujs
#= require jquery.tipsy
#= require jquery.validate
#= require chartjs.min
#= require bacon
#= require handlebars.runtime
#= require lodash
#= require headroom
#= require jquery.headroom
#= require_tree ./lib
#= require_tree ./templates
#= require header
#= require flash
#= require user


$ ->
  $('i').tipsy { gravity: 'n' }
  $('header').headroom()
