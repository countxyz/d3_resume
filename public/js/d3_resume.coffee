diagProj = (d) -> [d.y, d.x]

svgWidth = -> width + margin.right + margin.left

svgHeight = -> height + margin.top + margin.bottom

translation = -> "translate(" + margin.left + "," + margin.top + ")"

collapse = (d) ->
  if d.children
    d._children = d.children
    d._children.forEach collapse
    d.children = null

nodeSpacing = (d) -> d.y = d.depth * 180

updateNodes = (d) -> d.id || (d.id = ++i)

appendName = (d) -> d.name

targetLink = (d) -> d.target.id

trans = (d) -> "translate(" + source.y0 + "," + source.x0 + ")"

nodeFill = (d) -> if d._children then 'lightsteelblue' else '#fff'

nodeAppend = (d) -> if d.children or d._children then -10 else 10

nodeAnchor = (d) -> if d.children or d._children then 'end' else 'start'

updateFill = (d) -> if d._children then 'lightsteelblue' else '#fff'

newPosition = (d) -> "translate(" + source.y + "," + source.x + ")"

margin = { top: 20, right: 120, bottom: 20, left: 120 }
width = 960 - margin.right - margin.left
height = 800 - margin.top - margin.bottom

i = 0
duration = 750
root = undefined

tree = d3.layout.tree().size([height, width])

diagonal = d3.svg.diagonal().projection(diagProj)

svg = d3.select('body').append('svg')
    .attr('width', svgWidth)
    .attr('height', svgHeight)
  .append('g')
    .attr('transform', translation)

div = d3.select('body').append('div')
  .attr('class', 'tooltip')
  .style("opacity", 0)
  .text('tooltip')

d3.json '/data/journey.json', (error, journey) ->
  collapse
  root = journey
  root.x0 = height / 2
  root.y0 = 0
  root.children.forEach collapse
  update root
  return

d3.select(self.frameElement).style 'height', '800px'

update = (source) ->  
  nodes = tree.nodes(root).reverse()
  links = tree.links(nodes)
  
  nodes.forEach(nodeSpacing)

  node = svg.selectAll('g.node')
    .data(nodes, updateNodes)

  nodeEnter = node.enter().append('g')
    .attr('class', 'node')
    .attr('transform', (d) -> "translate(" + source.y0 + "," + source.x0 + ")")
    .on('click', click)
    .on('mouseover', (d) ->
      if d.description
        div.transition()
          .duration(200)
          .style('opacity', .9)
        div.html(d.description)
          .style('left', (d3.event.pageX) + 'px')
          .style('top', (d3.event.pageY - 28) + 'px'))
      .on('mouseout', (d) ->
        div.transition()
          .duration(500)
          .style('opacity', 0))

  nodeEnter.append('circle')
    .attr('r', 1e-6)
    .style 'fill', nodeFill

  nodeEnter.append('text')
    .attr('x', nodeAppend)
    .attr('dy', '.35em')
    .attr('text-anchor', nodeAnchor)
    .text(appendName)
    .style 'fill-opacity', 1e-6

  nodeUpdate = node.transition().duration(duration)
    .attr('transform', (d) -> "translate(" + d.y + "," + d.x + ")")

  nodeUpdate.select('circle').attr('r', 4.5).style 'fill', updateFill

  nodeUpdate.select('text').style 'fill-opacity', 1
  
  nodeExit = node.exit().transition().duration(duration)
    .attr('transform', (d) -> "translate(" + source.y + "," + source.x + ")")
    .remove()

  nodeExit.select('circle').attr 'r', 1e-6
  
  nodeExit.select('text').style 'fill-opacity', 1e-6
  
  link = svg.selectAll('path.link').data(links, targetLink)

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
    return

click = (d) ->
  if d.children
    d._children = d.children
    d.children = null
  else
    d.children = d._children
    d._children = null
  update d
  return
