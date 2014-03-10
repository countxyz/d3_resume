diagProj = (d) -> [d.y, d.x]

svgWidth = -> width + margin.right + margin.left

svgHeight = -> height + margin.top + margin.bottom

margin = { top: 20, right: 120, bottom: 20, left: 120 }
width = 960 - margin.right - margin.left
height = 800 - margin.top - margin.bottom

i = 0
duration = 750
root = undefined

tree = d3.layout.tree().size([height, width])

diagonal = d3.svg.diagonal().projection(diagProj)

svg = d3.select('body').append('svg')
  .attr('width', svgWidth).attr('height', svgHeight).append('g')
  .attr('transform', translation)
