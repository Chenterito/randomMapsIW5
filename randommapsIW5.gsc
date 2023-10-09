/*
*	 Black Ops 2 - GSC Studio by iMCSx
*
*	 Creator : Kalitos
*	 Project : Ramdoms Maps IW5
*    Mode : Multiplayer
*	 Date : 2023/08/20 - 
*
*/	

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

main()
{
	replacefunc(maps\mp\gametypes\_gamelogic::waittillFinalKillcamDone, ::finalkillcamhook);
}

init()
{
	level.mediumPLayers = 8;						
    level.highPLayers = 15;	
    level.lowpoolmaps = "mp_dome mp_hardhat mp_bravo mp_alpha"; //Separate each map you want to add with a space.				
    level.mediumpoolmaps = "mp_dome mp_hardhat mp_bravo mp_underground mp_bootleg mp_paris mp_seatown mp_terminal_cls mp_alpha"; //Separate each map you want to add with a space.					
    level.highpoolmaps = "mp_dome mp_hardhat mp_bravo mp_underground mp_bootleg mp_paris mp_seatown mp_terminal_cls mp_carbon mp_plaza2 mp_rust mp_radar mp_alpha"; //Separate each map you want to add with a space.		
    level.lowpoolmodes = "TDM_default"; //Separate each mode you want to add with a space.	
    level.mediumpoolmodes = "TDM_default DOM_default"; //Separate each mode you want to add with a space.
    level.highpoolmodes = "TDM_default DOM_default KC_default"; //Separate each mode you want to add with a space.
	level thread ramdommaps();
}

finalkillcamhook() {
    if (!IsDefined(level.finalkillcam_winner)) {
        ramdommaps();
        return false;
    } else {
        level waittill("final_killcam_done");
        ramdommaps();
        return true;
    }
}

ramdommaps()
{
    if (!waslastround()) return;
	
    numPLayers = getRealPlayer();
    mapwin = "";
    modewin = "";
    if(numPlayers >= level.highPLayers)
    {
        listmaps = strTok(level.highpoolmaps, " ");
        listmodes = strTok(level.highpoolmodes, " ");
        mapwin = listmaps[randomIntRange(0,listmaps.size)];
        modewin = listmodes[randomIntRange(0,listmodes.size)];
    }
    else if(numPlayers >= level.mediumPLayers)
    {
        listmaps = strTok(level.mediumpoolmaps, " ");
        listmodes = strTok(level.mediumpoolmodes, " ");
        mapwin = listmaps[randomIntRange(0,listmaps.size)];
        modewin = listmodes[randomIntRange(0,listmodes.size)];
    }
    else
    {
        listmaps = strTok(level.lowpoolmaps, " ");
        listmodes = strTok(level.lowpoolmodes, " ");
        mapwin = listmaps[randomIntRange(0,listmaps.size)];
        modewin = listmodes[randomIntRange(0,listmodes.size)];
    }

    wait .5;
    setDvar( "sv_maprotationcurrent", "dsr " + modewin + " map " + mapwin + ";" );
    logPrint("There are " + numPLayers + " players; " + "dsr " + modewin + " map " + mapwin + "; \n");
	wait .5;
}

getRealPlayer()
{
    players = level.players;
    numPLayers = 0;
    for(i=0;i<players.size;i++)
	{
		if(isDefined(players[i]) && isFalse(players[i].pers["isBot"]))
			numPLayers++;
	}
    return numPLayers;
}

isFalse(v) {
	return (!isDefined(v)||!v);
}
