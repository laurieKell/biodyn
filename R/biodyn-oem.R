## Observation Error Model
globalVariables("ctrl")
globalVariables("prrs")
globalVariables("cpue")
globalVariables("phaseQ")
globalVariables("bounds")
globalVariables("uCV")


#' sim
#'
#' @description Creates a biodyn object with known properties
#' 
#' @param model character corresponding to model
#' @param params surplus production parameters
#' @param harvest \code{FLQuant} with harvest rate
#' 
#' @param bounds on \code{control}
#' @param ... other arguments
#' 
#' @export
#' @rdname sim
#' 
#' @return biodyn object with simulated time series
#' 
#' @aliases sim-method sim,FLStock,ANY-method sim,missing,missing-method 
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#'  bd=sim() 
#'  }
setGeneric('sim',   function(stock,brp,...)     standardGeneric('sim'))
setMethod( 'sim',   signature(stock='missing',brp='missing'),
           function(params=FLPar(r=0.5, k=1000, p=1, b0=1.0),
                    harvest=FLQuant(FLQuant(c(seq(0,1.5,length.out=30), 
                                              rev(seq(0.5,1.5,length.out=15))[-1],
                                              rep(0.5,5)))*biodyn:::fmsy(biodyn("pellat",params=params))),
                    bounds =c(0.1,10),
                    p=NULL,b0=NULL,...) {

  args <- list(...)
  
  if (!is.null(p))  params["p"] =p
  if (!is.null(b0)) params["b0"]=b0
  
  nyr=dim(harvest)[2]
  stock =FLQuant(rep(params['k'], nyr), dimnames=dimnames(harvest))
  
  nyr <- dims(harvest)$year
  object = biodyn(model ='pellat',
                  stock =stock,
                  params=params)
  
  object@control['r',     'val']=params['r']
  object@control['k',     'val']=params['k']
  object@control['p',     'val']=params['p']
  object@control['b0',    'val']=params['b0']
  
  object@control[,'min']=object@control[,'val']*bounds[1]
  object@control[,'max']=object@control[,'val']*bounds[2]
  
  object@control['p', 'phase']=-1
  object@control['b0','phase']=-1
  object@priors[,1]=-1
  
  # Load given slots
  for(i in names(args))
    slot(object, i) <- args[[i]]
  
  object <- fwd(object, harvest=harvest)
  
  return(object)}) 

setMethod( 'sim', signature(stock='FLStock',brp='ANY'),function(stock,brp) {

  bd=biodyn:::biodyn(stock)
  
  params(bd)[dimnames(ctrl)$param]=ctrl[dimnames(ctrl)$param,'val']
  
  bd@priors=prrs
  setParams( bd)=cpue
  setControl(bd)=params(bd)
  bd@control[dimnames(ctrl)$params,'phase'][]=ctrl[dimnames(ctrl)$params,'phase']
  bd@control['q1','phase']=phaseQ
  bd@control['q1','val']  =1
  
  nyr <- dims(harvest)$year
  object = biodyn(model ='pellat',
                  stock =FLQuant(rep(params['k'], nyr), dimnames=dimnames(harvest)),
                  params=params)
  
  object@control['r',     'val']=params['r']
  object@control['k',     'val']=params['k']
  object@control['p',     'val']=params['p']
  object@control['b0',    'val']=params['b0']
  
  object@control[,'min']=object@control[,'val']*bounds[1]
  object@control[,'max']=object@control[,'val']*bounds[2]
  
  object@control['p', 'phase']=-1
  object@control['b0','phase']=-1
  object@priors[,1]=-1
  
  # Load given slots
  for(i in names(args))
    slot(object, i) <- args[[i]]
  
  object <- fwd(object, harvest=harvest)
  
  return(object)})

setGeneric('oem',   function(om,...)     standardGeneric('oem'))
setMethod( 'oem',   signature(om='FLStock'),
           function(om,cv=0.3,fishDepend=FALSE){
  
  nits=max(dims(stock(om))$iter,dims(catch(om))$iter)
  
  if ("numeric"%in%is(cv))
    cv=rlnorm(nits,FLQuant(0,dimnames=list(year=dims(om)$minyear:dims(om)$maxyear)),cv)
  
  yrs=dimnames(m(om))$year
  yrs=yrs[yrs%in%dimnames(cv)$year]
  if (fishDepend) 
    cpue=cv[,yrs]%*%catch(om)[,yrs]%/%fbar(om)[,yrs]
  else 
    cpue=cv[,yrs]%*%computeStock(om)[,yrs]

  cpue})

#setMethod('survey', signature(object='FLStock'),
survey=function(object,timing=FLQuant(0,dimnames=dimnames(m(object))),wt=stock.wt(object),sd=0,log=FALSE,...){
  
  if(units(harvest(object)) == 'f'){
    res      <- colSums(stock.n(object)*exp(-harvest(object)*timing - m(object)*timing)*wt, na.rm=FALSE)
    dim(res) <- c(1, dim(res))
    dmns     <-dimnames(stock(object))
    dmns$iter<-dimnames(res)$iter
    
    res=FLQuant(res, dimnames=dmns)
  } else if(units(harvest(object)) == 'hr') {
    
    res      = colSums(object@stock.n*(1-object@harvest*timing)*exp(-object@m*timing)*timing*wt)
    dim(res) = c(1, dim(res))
    
    res=FLQuant(res, dimnames=dimnames(object@stock))
  } else
    stop('Correct units (f or hr) not specified in the harvest slot')
  
  if (sd>0){
    if (!log) res=apply(res,2:6,function(x,sd) rnorm( 1,x,sd=sd),sd=sd) else 
      res=apply(res,2:6,function(x,sd) rlnorm(1,x,sdlog=sd),sd=sd)
  }
  
  res}

#setMethod('cpue', signature(object='FLStock'),
u=function(object,partialf=FLQuant(1,dimnames=dimnames(m(object))),wt=catch.wt(object),sd=0,log=FALSE,...){
  
  if(units(harvest(object)) == 'f'){
    res      <- colSums(stock.n(object)*harvest(object)*partialf/(harvest(object)+m(object))*exp(1-harvest(object)-m(object)), na.rm=FALSE)
    dim(res) <- c(1, dim(res))
    dmns     <-dimnames(stock(object))
    dmns$iter<-dimnames(res)$iter
    
    res=FLQuant(res, dimnames=dmns)
  } else if(units(harvest(object)) == 'hr') {
    
    res      = colSums(object@stock.n*(1-object@harvest*partialf)*exp(-object@m)*wt)
    dim(res) = c(1, dim(res))
    
    res=FLQuant(res, dimnames=dimnames(object@stock))
  } else
    stop('Correct units (f or hr) not specified in the harvest slot')
  
  if (sd>0){
    if (!log) res=apply(res,2:6,function(x,sd) rnorm( 1,x,sd=sd),sd=sd) else 
      res=apply(res,2:6,function(x,sd) rlnorm(1,x,sdlog=sd),sd=sd)}
  
  res} 

cpueBiodym2Aspic=function(bd,type='B0',n=1,sd=0,log=TRUE){
  
  type=toupper(type)
  effort=harvest(bd)
  if (n>1)  effort=propagate(effort,n)
  
  dmns=dimnames(stock(bd))
  dmns$iter=1              
  dev=if (log) rlnorm(n,FLQuant(0,dimnames=dmns),sd) else rnorm( n,FLQuant(0,dimnames=dmns),sd)
  
  ctc=stock(bd)[,-dims(bd)$year]*effort
  
  switch(type,
         
         ## Error on Catch
         CC={ res=cbind(name='CC sim',model.frame(mcf(FLQuants(effort=effort,catch=ctc,dev=dev)),drop=T, stringsAsFactors=FALSE))
              res=transform(res,catch=catch*dev,index=catch*dev/effort)
              res},
         
         ## Error on index
         CE={ res=cbind(name='CE sim',model.frame(mcf(FLQuants(effort=effort,catch=ctc,dev=dev)),drop=T, stringsAsFactors=FALSE))
              res=transform(res,index=catch*dev/effort)
         },   
         
         ## Error on stock
         B0=cbind(name='B0 sim',model.frame(mcf(FLQuants(stock=stock(bd)*dev)),drop=T, stringsAsFactors=FALSE)),
         B1=cbind(name='I1 sim',model.frame(mcf(FLQuants(stock=(stock(bd)[,-dim(stock(bd))[2]]+stock(bd)[,-1]/2),dev=dev)),drop=T, stringsAsFactors=FALSE)),
         B2={ res=cbind(name='I0 sim',model.frame(mcf(FLQuants(stock=stock(bd),dev=dev)),drop=T, stringsAsFactors=FALSE))
              res},          
         
         ## Error on stock
         I0=cbind(name='B0 sim',model.frame(mcf(FLQuants(index=.1*stock(bd)*dev)),drop=T, stringsAsFactors=FALSE)),
         I1=cbind(name='I1 sim',model.frame(mcf(FLQuants(index=.1*(stock(bd)[,-dim(stock(bd))[2]]+stock(bd)[,-1]/2),dev=dev)),drop=T, stringsAsFactors=FALSE)),
         I2={ res=cbind(name='I0 sim',model.frame(mcf(FLQuants(index=.1*stock(bd),dev=dev)),drop=T, stringsAsFactors=FALSE))
              res}                
  )}

oemFn<-function(flt,om,paa=paa,dev=uCV){
  
  res=apply(sweep(catch.n(om),1,paa[,flt],"*")*catch.wt(om),c(2,6),sum)
  
  if (!is.FLQuant(dev)){
    
    dev=rlnorm(dims(res)$iter,FLQuant(0,dimnames=dimnames(iter(res,1))),dev[flt])}
  
  res*dev[,dimnames(res)$year]}

