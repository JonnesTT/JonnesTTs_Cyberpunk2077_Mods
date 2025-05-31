registerForEvent("onInit", function()
	Override('UIInventoryItemStatsManager', 'InternalFetchStatByType', function( self, statType, statId, skipEmpty ) --> returns UIInventoryItemStat
			-- print(tostring(statType))
			-- spdlog.info(tostring(statType)) -- gamedataStatType : ProjectilesPerShot (1167)

			local gameItemDataStrong = self.gameItemData
			local value
			if gameItemDataStrong  then
				if( self.useBareStats ) then
					value = gameItemDataStrong:GetBareStatValueByType( statType )
				else
					value = gameItemDataStrong:GetStatValueByType( statType )
				end
			end
			local roundValue = TweakDBInterface.GetBool( statId + ".roundValue", false )
			local absValue = math.abs( value )
			if skipEmpty then
				if roundValue then
					if math.floor(absValue+0.5) <= 0 then
						return nil
					end
				else
					if absValue <= 0.001 then
						return nil
					end
				end
			end

			if(statType == gamedataStatType.ProjectilesPerShot and value == 1.0) then
				return nil
			end

			local itemStat = UIInventoryItemStat.new()
			itemStat.Type = statType
			itemStat.Value = value
			itemStat.PropertiesProvider = DefaultUIInventoryItemStatsProvider.Make( itemStat.Type, self.manager )
			return itemStat
	end)
end)
  