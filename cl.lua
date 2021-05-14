--
--LICENSE
--
--ZAKAZ USUWANIA TEKSTU Z TEGO PLIKU
--
--Całkowity zakaz jakiegokolwiek przekazywania skryptu.
--Konsekwencje odsprzedaży lub darmowego przekazania skryptu opisane jest w art. 116 KK
--Więcej informacji w http://www.prawoautorskie.pl/art-116	

local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }
  local PlayerData                = {}
  local PlayerLoaded              = false
  
  ESX                             = nil
  
  Citizen.CreateThread(function()
      while ESX == nil do
          TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
          Citizen.Wait(0)
      end
  
      while ESX.GetPlayerData().job == nil do
          Citizen.Wait(100)
      end
  
      PlayerLoaded = true
      ESX.PlayerData = ESX.GetPlayerData()
  end)
  RegisterNetEvent('esx:playerLoaded')
  AddEventHandler('esx:playerLoaded', function(xPlayer)
      ESX.PlayerData = xPlayer
      PlayerLoaded = true
  end)
  RegisterNetEvent('esx:setJob')
  AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
  end) 
  function ShowAdvancedNotification(title, subject, msg, icon, iconType)
      SetNotificationTextEntry('STRING')
      AddTextComponentString(msg)
      SetNotificationMessage(icon, icon, false, iconType, title, subject)
      DrawNotification(false, false)
  end
  RegisterNetEvent('heezzu_dowod_pokazDokument')
  AddEventHandler('heezzu_dowod_pokazDokument', function(id, imie, data, dodatek)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(pid))
    if pid == myId then
      ShowAdvancedNotification(imie, data, dodatek, mugshotStr, 8)
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 10.0 then
      ShowAdvancedNotification(imie, data, dodatek, mugshotStr, 8)
    end
    UnregisterPedheadshot(mugshot)
  end)

  RegisterNetEvent('pokazwizam')
AddEventHandler('pokazwizam', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
       TriggerEvent('chat:addMessage', {
        template = '<div style="padding: 0.4vw; margin: 0.0vw; background: linear-gradient(135deg, rgb(8, 249, 1,0.3) 0%, rgb(8, 249, 1,0.1) 100%); border-radius: 5px;"><i class="fas fa-user-circle"></i> ^7 ^r{0}^r:<br></div>',
        args = {'Obywatel ['  .. id .. ']: Pokazuje Anonimowa Wizytowke : ' .. name}
    })
  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
         TriggerEvent('chat:addMessage', {
        template = '<div style="padding: 0.4vw; margin: 0.0vw; background: linear-gradient(135deg, rgb(8, 249, 1,0.3) 0%, rgb(8, 249, 1,0.1) 100%); border-radius: 5px;"><i class="fas fa-user-circle"></i> ^7 ^r{0}^r:<br></div>',
        args = {'Obywatel ['  .. id .. ']: Pokazuje Anonimowa Wizytowke: ' .. name}
    })
  end
end)
  
  RegisterNetEvent('heezzu_dowod:sendProximityMessage')
  AddEventHandler('heezzu_dowod:sendProximityMessage',function(id, name, message)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    if pid == myId then 
      TriggerEvent('chat:addMessage', {
        args = {'^6Obywatel[' ..  name .. ']', message}
    })
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 10.0 then
      TriggerEvent('chat:addMessage', {
        args = {'^6Obywatel[' ..  name .. ']', message}
    })
    end
  end)
  function OpenDokumentMenu()
  
    local elements = {
        {label = 'Dowód Osobisty',     value = 'dowod'},
        {label = 'Wizytówka',          value = 'wizytowka'}, 
        {label = 'Anonimowa Wizytówka',          value = 'pokazwizam'}, 

        }
  
        if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
          table.insert(elements,{label = 'Odznaka Policyjna', value = 'odznaka'})
        end
  
        if PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' then
          table.insert(elements,{label = 'Legitymacja LSMC', value = 'legitymacja'})
        end
  
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'dok_menu',
      {
        title    = 'Dokumenty',
        align    = 'center',
        elements = elements
        },
            function(data2, menu2)
                if data2.current.value == 'dowod' then
                  TriggerServerEvent('heezzu_dowod:pokadowodzik')
                end
  
                if data2.current.value == 'wizytowka' then 
                  TriggerServerEvent('heezzu_dowod:pokawizytowke')
                end
                
                if data2.current.value == 'odznaka' then
                  TriggerServerEvent('heezzu_dowod:pokaodznake')
                end
  
                if data2.current.value == 'legitymacja' then
                  TriggerServerEvent('heezzu_dowod:pokalegitke')
                end

                if data2.current.value == 'pokazwizam' then
                  TriggerServerEvent('heezzu_dowod:pokawizytowkeanonimowa')
                end
  
            end,
            function(data, menu)
            menu.close()
          end)
  end
  
  RegisterNetEvent('heezzu_dowod_pokazwizam')
AddEventHandler('heezzu_dowod_pokazwizam', function(id, imie, data, dodatek)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(pid))
  if pid == myId then
    SetNotificationBackgroundColor(200)
    TriggerEvent('esx:showAdvancedNotification', imie, data, dodatek, mugshotStr)
		chowaniebronianim()
		pokazdowodanim()
		portfeldowodprop1()
  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 9.999 then
    SetNotificationBackgroundColor(200)
    TriggerEvent('esx:showAdvancedNotification', imie, data, dodatek, mugshotStr)

  end
  
  UnregisterPedheadshot(mugshot)

end)

  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      local ped = PlayerPedId()
  
      if IsControlJustPressed(1, Keys['F9']) and not IsEntityDead(ped) then
        OpenDokumentMenu()
      end
    end
  end)
