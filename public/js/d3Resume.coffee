svgWidth = -> width + margin.right + margin.left

svgHeight = -> height + margin.top + margin.bottom

collapse = (d) ->
  if d.children
    d._children = d.children
    d._children.forEach collapse
    d.children = null

nodeSize = (d) -> if d.value then d.value else 5

nodeAppend = (d) ->
  if d.children || d._children then (d.value + 4) * -1 else d.value + 4

updateFill = (d) -> if d.fill then d.fill else '#fff'

margin = { top: 20, right: 80, bottom: 20, left: 80 }
width  = 1050 - margin.right - margin.left
height = 800  - margin.top   - margin.bottom

i = 0
duration = 750
root = undefined

tree = d3.layout.tree().size([height, width])

diagonal = d3.svg.diagonal().projection (d) -> [d.y, d.x]

svg = d3.select('body').append 'svg'
    .attr('width', svgWidth).attr 'height', svgHeight
  .append 'g'
    .attr 'transform', "translate(" + margin.left + "," + margin.top + ")"

div = d3.select('body').append 'div'
  .attr('class', 'tooltip').style('opacity', 0).text 'tooltip'

d3.json '/data/journey.json', (error, journey) ->
  collapse
  root    = journey
  root.x0 = height / 2
  root.y0 = 0
  root.children.forEach collapse
  update root

d3.select(self.frameElement).style 'height', '800px'

update = (source) ->  
  nodes = tree.nodes(root).reverse()
  links = tree.links nodes
  
  nodes.forEach (d) -> d.y = d.depth * 160

  node = svg.selectAll('g.node').data nodes, (d) -> d.id || (d.id = ++i)

  nodeEnter = node.enter().append('g')
    .attr('class', 'node')
    .attr('transform', (d) -> "translate(" + source.y0 + "," + source.x0 + ")")
    .on('click', click)
    .on('mouseover', (d) -> if d.description
      div.transition().duration(200).style 'opacity', 1
      div.html(
        '<span>' + d.heading + '</span>' + '<br/>' +
        '<span>' + d.subheading + '</span>'+ '<br/>' + '<hr/>' + d.description)
        .style('left', (d3.event.pageX + 150) + 'px')
        .style('top', (d3.event.pageY - 35) + 'px'))
    .on('mouseout', (d) -> div.transition().duration(500).style 'opacity', 0)

  nodeEnter.append 'circle'
    .attr 'r', 1e-6
    .style 'fill', (d) -> if d._children then 'lightsteelblue' else '#fff'

  nodeEnter.append('text')
    .attr('x', nodeAppend).attr 'dy', '.35em'
    .attr 'text-anchor', (d) -> if d.children || d._children then 'end' else 'start'
    .text (d) -> d.name
    .style 'fill-opacity', 1e-6

  nodeUpdate = node.transition().duration(duration)
    .attr('transform', (d) -> "translate(" + d.y + "," + d.x + ")")

  nodeUpdate.select('circle').attr('r', nodeSize).style 'fill', updateFill

  nodeUpdate.select('text').style 'fill-opacity', 1
  
  nodeExit = node.exit().transition().duration(duration)
    .attr('transform', (d) -> "translate(" + source.y + "," + source.x + ")")
    .remove()

  nodeExit.select('circle').attr 'r', 1e-6
  
  nodeExit.select('text').style 'fill-opacity', 1e-6
  
  link = svg.selectAll('path.link').data(links, (d) -> d.target.id)

  link.enter().insert('path', 'g').attr('class', 'link').attr 'd', (d) ->
    o = { x: source.x0, y: source.y0 }
    diagonal({ source: o, target: o })

  link.transition().duration(duration).attr 'd', diagonal
  
  link.exit().transition().duration(duration).attr('d', (d) ->
    o = { x: source.x0, y: source.y0 }
    diagonal({ source: o, target: o })).remove()

  nodes.forEach (d) ->
    d.x0 = d.x
    d.y0 = d.y

click = (d) ->
  if d.children
    d._children = d.children
    d.children = null
  else
    d.children = d._children
    d._children = null
  update d
