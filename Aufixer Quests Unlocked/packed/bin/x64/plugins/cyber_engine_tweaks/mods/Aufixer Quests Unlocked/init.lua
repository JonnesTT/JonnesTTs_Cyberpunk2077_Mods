registerForEvent("onInit", function()
  
  ObserveAfter("PlayerDevelopmentSystem", "OnLevelUpProficiency", function(self, request)
    if not Game.GetQuestsSystem():GetFact("sa_ep1_courier_introduction_quest_finished") then
      if request.proficiencyType == gamedataProficiencyType.StreetCred then 
        if self.playerData:GetProficiencyLevel( gamedataProficiencyType.StreetCred ) >=20 then
          Game.GetQuestsSystem():SetFact( "sa_ep1_courier_introduction_quest_finished", 1 )
        end
      end
    end
  end)
end)