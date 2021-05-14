
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local katb = false
local kata = false
local katc = false
local jestb = 'nil'

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			name = identity['name'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height'],
			phone_number = identity['phone_number'],
			job = identity['job'],
			job_grade = identity['job_grade']

                        
		}
	else
		return nil
	end
end

function getlicenseA(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM user_licenses WHERE type = @type and owner = @owner",
    {
      ['@owner']   = identifier,
      ['@type'] = 'drive_bike'

    })


	if result[1] ~= nil then
		kata = true
		jesta = '~g~A'
	else
		jesta = '~r~A'
	end
end

function getlicenseB(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM user_licenses WHERE type = @type and owner = @owner",
    {
      ['@owner']   = identifier,
      ['@type'] = 'drive'

    })


	if result[1] ~= nil then
		katb = true
		jestb = '~g~B'
	else
		jestb = '~r~B'
	end
end

function getlicenseC(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM user_licenses WHERE type = @type and owner = @owner",
    {
      ['@owner']   = identifier,
      ['@type'] = 'drive_truck'

    })


	if result[1] ~= nil then
		katc = true
		jestc = '~g~C'
	else
		jestc = '~r~C'
	end
end


function getlicenseW(source)
	local identifier = GetPlayerIdentifiers(source)[1]

	local result = MySQL.Sync.fetchAll("SELECT * FROM user_licenses WHERE type = @type and owner = @owner",
    {
      ['@owner']   = identifier,
      ['@type'] = 'weapon'

    })


	if result[1] ~= nil then
		jestw = '~g~TAK~n~ ~s~'
	else
		jestw = '~r~NIE~n~ ~s~'
	end
end




function getlicenseOC(source)
	local identifier = GetPlayerIdentifiers(source)[1]

	local result = MySQL.Sync.fetchAll("SELECT * FROM user_licenses WHERE type = @type and owner = @owner and @data > data",
    {
      ['@owner']   = identifier,
      ['@type'] = 'OC',
	  ['@data'] = os.year
    })


	if result[1] ~= nil then
		jestOC = '~g~OC~s~'
	else
		jestOC = '~r~OC~s~'
	end
end

function getlicenseNW(source)
	local identifier = GetPlayerIdentifiers(source)[1]

	local result = MySQL.Sync.fetchAll("SELECT * FROM user_licenses WHERE type = @type and owner = @owner and @data > data",
    {
      ['@owner']   = identifier,
      ['@type'] = 'NW',
	  ['@data'] = os.year
    })


	if result[1] ~= nil then
		jestNW = '~g~NW~s~'
	else
		jestNW = '~r~NW~s~'
	end
end


RegisterServerEvent('heezzu_dowod:pokadowodzik')
AddEventHandler('heezzu_dowod:pokadowodzik', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local name = getIdentity(source)
	local lickaB = getlicenseB(source)
	local lickaA = getlicenseA(source)
	local lickaC = getlicenseC(source)
	local lickaW = getlicenseW(source)
	local lickaNW = getlicenseNW(source)
	local lickaOC = getlicenseOC(source)
	local imie = name.firstname .. ' ' .. name.lastname
    local message = '^6 Wręcza dowód osobisty : ' .. imie 
	local sex = ""
	local ubez = jestNW .. ' ' .. jestOC
	local pj 	= jesta .. ' ' .. jestb .. ' ' .. jestc
	sex = name.sex 

    TriggerClientEvent('heezzu_dowod_pokazDokument', -1, _source,  '~h~'..name.firstname..' '..name.lastname,'~y~'.. name.dateofbirth .. ' '.. sex .. ' ' .. name.height .. ' cm ','~w~Pozwolenie na broń ' ..jestw.. --[['Ubezpieczenie ' .. ubez ..]] 'Prawo Jazdy ' .. pj)
    TriggerClientEvent('heezzu_dowod:sendProximityMessage', -1, _source, _source, message)
end)


RegisterServerEvent('heezzu_dowod:pokawizytowke')
AddEventHandler('heezzu_dowod:pokawizytowke', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local name = getIdentity(source)
	local number = name.phone_number
	local job = xPlayer.job
	local message = '^6 Pokazuje wizytówkę : ' .. number
	TriggerClientEvent('heezzu_dowod_pokazDokument', -1,_source,  'Wizytówka',name.firstname..' '..name.lastname,'~y~Numer Telefonu : ~w~'..name.phone_number)
	TriggerClientEvent('heezzu_dowod:sendProximityMessage', -1, _source, _source, message)
end)



RegisterServerEvent('heezzu_dowod:pokaodznake')
AddEventHandler('heezzu_dowod:pokaodznake', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local job = xPlayer.job
	local name = getIdentity(source)
	local stopien = job.grade_label
	local imie = name.firstname .. ' ' .. name.lastname
	local message = '^6 Pokazuje odznake policjanta : ' .. imie .. ' '.. stopien
	local czy_wazna
	if job.name == "police" then
		czy_wazna = "~g~Tak"
	else
		job.grade_label = "~r~Brak informacji"
		czy_wazna = "~r~Nie"
	end
	TriggerClientEvent('esx:dowod_pokazDokument', -1,_source, '~h~'..name.firstname..' '..name.lastname,'Odznaka LSPD','Stopień: ~b~'..job.grade_label..'~n~~s~Odznaka jest ważna: '..czy_wazna)
	TriggerClientEvent('esx_dowod:sendProximityMessage', -1, _source, _source, message)
end)

TriggerEvent('es:addCommand', 'wizam', function(source, args, user)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

 	local name = getIdentity(source)

	TriggerClientEvent('heezzu_dowod_pokazwizam', -1,_source,  'Anonimowa Wizytowka','~y~Numer Telefonu : ~r~'..name.phone_number)
	TriggerClientEvent("pokazujewizam", -1, _source, table.concat(args, " "))
end)


RegisterServerEvent('heezzu_dowod:pokalegitke')
AddEventHandler('heezzu_dowod:pokalegitke', function()
local _source = source
local xPlayer = ESX.GetPlayerFromId(_source)
local job = xPlayer.job
local name = getIdentity(source)
local stopien = job.grade_label
local imie = name.firstname .. ' ' .. name.lastname
local message = '^6 Pokazuje Licencje Medyczna : ' .. imie .. ' '.. stopien
local czy_wazna
if job.name == "ambulance" then
	czy_wazna = "~g~Tak"
else
	job.grade_label = "~r~Brak informacji"
	czy_wazna = "~r~Nie"
end
	TriggerClientEvent('heezzu_dowod_pokazDokument', -1,_source, '~h~'..name.firstname..' '..name.lastname,'Legitymacja EMS','Stopień: ~b~'..job.grade_label..'~n~~s~Legitymacja jest ważna: '..czy_wazna)
	TriggerClientEvent('heezzu_dowod:sendProximityMessage', -1, _source, _source, message)
end)

ESX.RegisterUsableItem('portfel', function(source)
	TriggerClientEvent('heezzu_dowod:OpenDokumentMenu', source)
	Wait(2000)
end)