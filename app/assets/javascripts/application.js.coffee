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
#= require poll

@colors  = [
    colorName:  'red'
    color:      '#E96950'
    highlight:  '#B35340'
  ,
    colorName:  'green'
    color:      '#42b983'
    highlight:  '#359368'
  ,
    colorName:  'yellow'
    color:      '#ffc870'
    highlight:  '#fdb45c'
  ,
    colorName:  'blue'
    color:      '#6189a1'
    highlight:  '#517083'
  ]

@repeatedly = (arr) ->
  i = 0
  ->
    i = 0 if i >= arr.length
    arr[i++]

$ ->
  $('i').tipsy { gravity: 'n' }
  $('header').headroom()
