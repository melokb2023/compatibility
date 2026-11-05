% ==============================================================================
% Name of the Course: Introduction to Artificial Intelligence
% Prolog AI Project: Hardware Specifications & Compatibility Engine for PC Games
% Name of the File: comp.pl
% What is this Program: 
%   This is a Prolog program that models PC hardware configurations, 
%   system requirements, power hierarchies, and constraints in storage to infer 
% the playability of the system and determine the bottleneck components.
% ==============================================================================

% ==============================================================================
% 1. Setting Up The Facts: User PC Configurations, Game Requirements, and Hardware Component Power Hierarchy
% ==============================================================================

% ------------------------------------------------------------------------------
% Fact Statement: Configuration of User PCs
% Format Followed: build(PC_ID, CPU_Tier, RAM_GB, GPU_Tier, StorageType)
% Tiers supported: low, mid, high, enthusiast
% Storage types: hdd, ssd
% ------------------------------------------------------------------------------
build(rig_alpha, high, 32, high, ssd).        % High-end Gaming Rig for the 1st Build
build(rig_beta, mid, 16, mid, hdd).          % Mainly Mid-range PC (HDD build) for the 2nd Build
build(rig_gamma, enthusiast, 64, enthusiast, ssd). % Top-tier workstation/gaming rig for the 3rd Build
build(rig_budget, low, 8, low, hdd).          % Entry-level budget office/gaming PC for the 4th Build

% ------------------------------------------------------------------------------
% 2nd Fact Statement: Game System Requirements for a Specific Game
% Format to Follow: game(title, cpuTierLevel, minRAMGB, minGPUTier, ssdRequired)
% ------------------------------------------------------------------------------
% 2026 Modern & Next-Gen Titles (Heavy Demands)
game(oo7_first_light, high, 16, high, true).
game(crimson_desert, high, 16, high, true).
game(gta_6, high, 32, high, true).
game(forza_horizon_6, high, 16, high, true).
game(monster_hunter_wilds, high, 32, high, true).
game(doom_the_dark_ages, high, 16, high, true).

% Mid-Tier / Popular Modern Releases
game(cyberpunk_2077, mid, 16, mid, true).
game(baldurs_gate_3, mid, 16, mid, true).
game(cs2, mid, 12, mid, true).

% Lightweight / Esports / Indie Titles
game(dota_2, low, 8, low, false).
game(hades_2, low, 8, low, false).
game(indie_pixel_game, low, 4, low, false).
game(wii_sports, low, 4, low, false).
game(valorant, low, 4, low, false).

% ------------------------------------------------------------------------------
% 3rd Fact Statement: Hardware Component Power Hierarchy
% Details the  qualitative component tiers via numerical ranks for comparison.
% ------------------------------------------------------------------------------
hardwareranking(low, 1).
hardwareranking(mid, 2).
hardwareranking(high, 3).
hardwareranking(enthusiast, 4).

% ==============================================================================
% RULES OF LOGICAL INFERENCE: System Evaluation and Comparison Rules for Game Playability
% ==============================================================================

% ------------------------------------------------------------------------------
% RULE: Comparing Between Tiers (Transitive / Ordinal Evaluation)
% higher_or_equal_tier(UserTier, RequiredTier)
% It evaluates whether a user's hardware tier meets or exceeds the given tier.
% ------------------------------------------------------------------------------
higher_or_equal_tier(UTier, RTier) :-
    hardwareranking(UTier, URank),
    hardwareranking(RTier, RRank),
    URank >= RRank.

% ------------------------------------------------------------------------------
% 1st Rule: Checking if the CPU Tier is Sufficient for the Game
% Evaluates if the PC's CPU tier satisfies the game's minimum CPU tier requirement.
% ------------------------------------------------------------------------------
can_run_cpu(PCName, GameTitle) :-
    build(PCName, UserCurrentCPU, _, _, _),
    game(GameTitle, SystemRequiredCPU, _, _, _),
    higher_or_equal_tier(UserCurrentCPU, SystemRequiredCPU).

% ------------------------------------------------------------------------------
% 2nd Rule: Checking the RAM Capacity of the System
% Evaluates if system RAM (in GB) is greater than or equal to the required RAM.
% ------------------------------------------------------------------------------
can_run_ram(PCName, GameTitle) :-
    build(PCName, _, UserCurrentRAM, _, _),
    game(GameTitle, _, SystemRequiredRAM, _, _),
    UserCurrentRAM >= SystemRequiredRAM.

% ------------------------------------------------------------------------------
% RULE 3: GPU Compatibility Check
% Evaluates if the PC's GPU tier satisfies the game's minimum GPU tier requirement.
% ------------------------------------------------------------------------------
can_run_gpu(PCName, GameTitle) :-
    build(PCName, _, _, UserCurrentGPU, _),
    game(GameTitle, _, _, SystemRequiredGPU, _),
    higher_or_equal_tier(UserCurrentGPU, SystemRequiredGPU).

% ------------------------------------------------------------------------------
% RULE 4: Checking if There Is Enough Storage for the Game
% Checks if the system storage meets the game's SSD requirements.
% ------------------------------------------------------------------------------
can_run_storage(PCName, GameTitle) :-
    build(PCName, _, _, _, UserCurrentStorage),
    game(GameTitle, _, _, _, SystemRequiredSSD),
    (SystemRequiredSSD = false ; (SystemRequiredSSD = true, UserCurrentStorage = ssd)).

% ==============================================================================
% 3. Master Evaluation and Bottleneck Identification Rules for Game Playability
% ==============================================================================

% ------------------------------------------------------------------------------
% MASTER RULE: Full Game Playability Verification
% can_run_game(PCName, GameTitle)
% Will succeed and run if only all four hardware constraints (CPU, RAM, GPU, Storage) have met or exceed the given requirements.
% ------------------------------------------------------------------------------
can_run_game(PCName, GameTitle) :-
    can_run_cpu(PCName, GameTitle),
    can_run_ram(PCName, GameTitle),
    can_run_gpu(PCName, GameTitle),
    can_run_storage(PCName, GameTitle).

% ------------------------------------------------------------------------------
% Important Rule to Follow and Take into Action: Find Bottlenecks Why the GAME Cannot Run on the PC
% Identifies specific hardware components causing failure for a given PC and Game.
% ------------------------------------------------------------------------------
bottleneck(PCName, GameTitle, cpu_too_weak) :-
    \+ can_run_cpu(PCName, GameTitle).

bottleneck(PCName, GameTitle, insufficient_ram) :-
    \+ can_run_ram(PCName, GameTitle).

bottleneck(PCName, GameTitle, gpu_too_weak) :-
    \+ can_run_gpu(PCName, GameTitle).

bottleneck(PCName, GameTitle, ssd_required) :-
    \+ can_run_storage(PCName, GameTitle).

% ==============================================================================
% 4. Starting the Program: Entry Point for Execution
% ==============================================================================
start :- true.