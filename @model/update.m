function m=update(mod, ellist, Pfin, Ufin )
% MODEL/UPDATE Update element list with new state
% M=UPDATE(MOD,ELEMLIST,PFIN,UFIN) Update model MOD with element list ELEMLIST
% and final load vector, PFIN, and final displacement vector, UFIN.

mod.ELEMLIST = ellist;
mod.Pfinal   = Pfin;
mod.Ufinal   = Ufin;

m = mod;
