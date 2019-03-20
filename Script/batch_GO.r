### GO database analysis 

g_list=list(gene_up=gene_up,
            gene_down=gene_down,
            gene_diff=gene_diff)

if(F){
  go_enrich_results <- lapply( g_list , function(gene) {
    lapply( c('BP','MF','CC') , function(ont) {
      cat(paste('Now process ',ont ))
      ego <- enrichGO(gene          = gene,
                      universe      = gene_all,
                      OrgDb         = org.Hs.eg.db,
                      ont           = ont ,
                      pAdjustMethod = "BH",
                      pvalueCutoff  = 0.99,
                      qvalueCutoff  = 0.99,
                      readable      = TRUE)
      
      print( head(ego) )
      return(ego)
    })
  })
  save(go_enrich_results,file = 'go_enrich_results.Rdata')
  
}


load(file = 'go_enrich_results.Rdata')

n1= c('gene_up','gene_down','gene_diff')
n2= c('BP','MF','CC') 
for (i in 1:3){
  for (j in 1:3){
    fn=paste0('dotplot_',n1[i],'_',n2[j],'.png')
    cat(paste0(fn,'\n'))
    png(fn,res=150,width = 1080)
    print( dotplot(go_enrich_results[[i]][[j]] ))
    dev.off()
  }
}