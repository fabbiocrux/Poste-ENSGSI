
```{r, echo=FALSE, out.width = '100%', fig.align='center', include=FALSE, eval=FALSE}
#sankey <- papers %>% filter(Document %in% c('Article', 'Conference Paper', 'Congrès'))
#sankey <- papers 
papers %>% group_by(Document) %>% summarise(value = n()) 


sankey <- 
   papers %>% group_by(Year, Level) %>% summarise(value = n()) %>% set_names("source", "target", "value")

# sankey <- 
#    papers %>% group_by(Document, Level) %>% summarise(value = n()) %>% set_names("source", "target", "value")
#sankey1$source <- as.character(sankey1$source)

#sankey <- rbind(sankey1, sankey2)


# From these flows we need to create a node data frame: it lists every entities involved in the flow
nodes <- data.frame(name=c(as.character(sankey$source), as.character(sankey$target)) %>% unique())

# With networkD3, connection must be provided using id, not using real name like in the links dataframe.. So we need to reformat it.
sankey$IDsource=match(sankey$source, nodes$name)-1 
sankey$IDtarget=match(sankey$target, nodes$name)-1

# prepare colour scale
ColourScal ='d3.scaleOrdinal() .range(["#FDE725FF","#B4DE2CFF","#6DCD59FF","#35B779FF","#1F9E89FF","#26828EFF","#31688EFF","#3E4A89FF","#482878FF","#440154FF"])'


# Make the Network
sankeyNetwork(Links = sankey, Nodes = nodes,
              Source = "IDsource", Target = "IDtarget",
              Value = "value", NodeID = "name", 
              sinksRight=FALSE, colourScale=ColourScal, nodeWidth=40, fontSize=13, nodePadding=20)

```

