
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath}

wall_of_weapons := class(creative_device):

    var Players : []player = array{}
    @editable var KillCounter : kill_counter_device = kill_counter_device{}
    @editable var Weapons : []weapon = array{}

    BtnInteractTxt<localizes>(Message : string) : message = "{Message}"

    OnBegin<override>()<suspends>:void=
        set Players = GetPlayspace().GetPlayers()
        if (Player := Players[0]):
            KillCounter.CreateUI(Player)

        InitWeapons()

    InitWeapons<private>():void=
        for (Weapon : Weapons):
                ## set button properties
                Message := "{Weapon.Name} ({Weapon.Cost} {Weapon.ResourceType})"
                Weapon.Button.SetInteractionText(BtnInteractTxt(Message))

                ## subscribe to button interaction event
                Weapon.Button.InteractedWithEvent.Subscribe(
                        weapon_handler{Device:=Self, Weapon:=Weapon}.HandleIt
                    )
                
    BuyWeapon(Weapon : weapon):void =
        if(KillCounter.KillCount >= Weapon.Cost):
            if(Player := Players[0]):
                Weapon.ItemGranter.GrantItem(Player)
        else:
            Message := "Not enough kills to buy the {Weapon.Name} (you have {KillCounter.KillCount})"
            Print("{Message}")

wall_item := class():
    var ResourceType : string = "kills"

weapon := class<concrete>(wall_item):
    @editable var Name : string = ""
    @editable var Cost : int = 0
    @editable var Button : button_device = button_device{}
    @editable var ItemPlacer : item_placer_device = item_placer_device{}
    @editable var ItemGranter : item_granter_device = item_granter_device{}

weapon_handler := class():
    Device : wall_of_weapons
    Weapon : weapon

    HandleIt(Agent : agent) : void = 
        Device.BuyWeapon(Weapon)