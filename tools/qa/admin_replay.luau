local T=game.ServerScriptService.Tower
local N=require(T.NightLoopService)
local S=require(T.RunStore)
local A=require(T.AdminService)
local p=game.Players:GetPlayers()[1]
local function tick() N.step(workspace:GetServerTimeNow()) end
local ok,err=pcall(function()
 N.reset()
 for trial=1,2 do
  N.adminNight(1); A.apply(p,"jar",1000)
  N.depart(); S.deadline=0;tick(); S.deadline=0;tick()
  N.adminResult(true);tick();S.graceEnd=0.001;tick();S.deadline=0;tick()
  assert(S.phase=="RESULT_SUCCESS","revisited night must settle")
 end
end)
workspace:SetAttribute("PTCAdminReplayQA",if ok then "PASS" else tostring(err))
print("[PTC QA] Revisited night: "..tostring(ok).." "..tostring(err))
