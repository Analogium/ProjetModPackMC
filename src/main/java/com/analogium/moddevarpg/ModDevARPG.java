package com.analogium.moddevarpg;

import org.slf4j.Logger;

import com.mojang.logging.LogUtils;

import net.neoforged.fml.common.Mod;

// Point d'entrée commun : chargé sur le client et sur le serveur dédié.
// Ne jamais y référencer net.minecraft.client.* (voir init.md, § 5).
@Mod(ModDevARPG.MODID)
public class ModDevARPG {
    public static final String MODID = "moddevarpg";
    public static final Logger LOGGER = LogUtils.getLogger();
}
