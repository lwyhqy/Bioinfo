#logistic回归
spli <- function(out,x,df=data){
  index=colnames(df)
  i=which(x==index)
  colnames(df)[i]="value"
  index=colnames(df)
  d <<- datadist(df[-1])
  options(datadist='d')
  formula=paste(index[1],"~",paste(index[-c(1,i)],collapse="+"),"+rcs(value,3)")
  fit <- lrm(formula = formula(formula),data=tmp)
  p=with(tmp,ggplot(Predict(fit, value, ref.zero=TRUE, fun=exp)))
  a=ggplot_build(p)$data[[2]]
  ggplot(data=a,aes(x,y))+geom_line(data=a,aes(x,y=y),linetype=1,color="black")+
    geom_line(data=a,aes(x,y=ymin),linetype=6,color="black")+
    geom_line(data=a,aes(x,y=ymax),linetype=6,color="black")+theme_classic()+
    labs(x=name,y="OR",title=out)+theme(axis.title = element_text(size=15),
                                        axis.text = element_text(size=15),
                                        plot.title = element_text(hjust = 0.5,size=20))+
    geom_abline(slope = 0,intercept = 1,linetype=2)
}
#cox回归
#coxdata
dd <- with(coxdata,datadist(age, sex))
options(datadist='dd')
S <- with(coxdata,Surv(dt,e))

f <- cph(S ~ rcs(age,4) + sex, x=TRUE, y=TRUE,data=coxdata)
cox.zph(f, "rank")             # tests of PH
anova(f)
with(coxdata,plot(Predict(f, age, sex))) # plot age effect, 2 curves for 2 sexes