% ==============================================================================
% COURSE: Introduction to Artificial Intelligence
% PROJECT: PC Game Hardware Specifications & Compatibility Engine
% FILE: pc_game_compatibility.pl
% DESCRIPTION: 
%   An expert system written in Prolog that models PC hardware configurations, 
%   game system requirements, component power hierarchies, and storage 
%   constraints to infer system playability and pinpoint bottlenecks.
% ==============================================================================

% ==============================================================================
% 1. KNOWLEDGE BASE: FACTS
% ==============================================================================

% ------------------------------------------------------------------------------
% FACT: User PC Configurations
% Format: user_pc(PC_ID, CPU_Tier, RAM_GB, GPU_Tier, StorageType)
% Tiers supported: low, mid, high, enthusiast
% Storage types: hdd, ssd
% ------------------------------------------------------------------------------
user_pc(rig_alpha, high, 32, high, ssd).        % High-end gaming rig
user_pc(rig_beta, mid, 16, mid, hdd).          % Mainstream mid-range PC (HDD build)
user_pc(rig_gamma, enthusiast, 64, enthusiast, ssd). % Top-tier workstation/gaming rig
user_pc(rig_budget, low, 8, low, hdd).          % Entry-level budget office/gaming PC

% ------------------------------------------------------------------------------
% FACT: Game System Requirements
% Format: game_requirement(GameTitle, MinCPUTier, MinRAM_GB, MinGPUTier, RequiresSSD)
% ------------------------------------------------------------------------------
% 2026 Modern & Next-Gen Titles (Heavy Demands)
game_requirement(oo7_first_light, high, 16, high, true).
game_requirement(crimson_desert, high, 16, high, true).
game_requirement(gta_6, high, 32, high, true).
game_requirement(forza_horizon_6, high, 16, high, true).
game_requirement(monster_hunter_wilds, high, 32, high, true).
game_requirement(doom_the_dark_ages, high, 16, high, true).

% Mid-Tier / Popular Modern Releases
game_requirement(cyberpunk_2077, mid, 16, mid, true).
game_requirement(baldurs_gate_3, mid, 16, mid, true).
game_requirement(cs2, mid, 12, mid, true).

% Lightweight / Esports / Indie Titles
game_requirement(dota_2, low, 8, low, false).
game_requirement(hades_2, low, 8, low, false).
game_requirement(indie_pixel_game, low, 4, low, false).

% ------------------------------------------------------------------------------
% FACT: Hardware Component Power Hierarchy
% Maps qualitative component tiers to numerical rankings for comparison.
% ------------------------------------------------------------------------------
tier_rank(low, 1).
tier_rank(mid, 2).
tier_rank(high, 3).
tier_rank(enthusiast, 4).

% ==============================================================================
% 2. LOGICAL INFERENCE RULES
% ==============================================================================

% ------------------------------------------------------------------------------
% RULE: Tier Comparison Rule (Transitive / Ordinal Evaluation)
% higher_or_equal_tier(UserTier, RequiredTier)
% Evaluates whether a user's hardware tier meets or exceeds the required tier.
% ------------------------------------------------------------------------------
higher_or_equal_tier(UserTier, RequiredTier) :-
    tier_rank(UserTier, URank),
    tier_rank(RequiredTier, RRank),
    URank >= RRank.

% ------------------------------------------------------------------------------
% RULE 1: CPU Compatibility Check
% Evaluates if the PC's CPU tier satisfies the game's minimum CPU tier requirement.
% ------------------------------------------------------------------------------
can_run_cpu(PCName, Game) :-
    user_pc(PCName, UserCPU, _, _, _),
    game_requirement(Game, ReqCPU, _, _, _),
    higher_or_equal_tier(UserCPU, ReqCPU).

% ------------------------------------------------------------------------------
% RULE 2: RAM Capacity Check
% Evaluates if system RAM (in GB) is greater than or equal to required RAM.
% ------------------------------------------------------------------------------
can_run_ram(PCName, Game) :-
    user_pc(PCName, _, UserRAM, _, _),
    game_requirement(Game, _, ReqRAM, _, _),
    UserRAM >= ReqRAM.

% ------------------------------------------------------------------------------
% RULE 3: GPU Compatibility Check
% Evaluates if the PC's GPU tier satisfies the game's minimum GPU tier requirement.
% ------------------------------------------------------------------------------
can_run_gpu(PCName, Game) :-
    user_pc(PCName, _, _, UserGPU, _),
    game_requirement(Game, _, _, ReqGPU, _),
    higher_or_equal_tier(UserGPU, ReqGPU).

% ------------------------------------------------------------------------------
% RULE 4: Checking if There Is Enough Storage for the Game
% Checks if the system storage meets the game's SSD requirements.
% ------------------------------------------------------------------------------
can_run_storage(PCName, Game) :-
    user_pc(PCName, _, _, _, UserStorage),
    game_requirement(Game, _, _, _, ReqSSD),
    (ReqSSD = false ; (ReqSSD = true, UserStorage = ssd)).

% ==============================================================================
% 3. MASTER EVALUATION & DIAGNOSTIC RULES
% ==============================================================================

% ------------------------------------------------------------------------------
% MASTER RULE: Full Game Playability Verification
% can_run_game(PCName, Game)
% Succeeds ONLY IF all four hardware constraints (CPU, RAM, GPU, Storage) are met.
% ------------------------------------------------------------------------------
can_run_game(PCName, Game) :-
    can_run_cpu(PCName, Game),
    can_run_ram(PCName, Game),
    can_run_gpu(PCName, Game),
    can_run_storage(PCName, Game).

% ------------------------------------------------------------------------------
% AUXILIARY RULE: Find Bottleneck Reason(s) for Failure
% Identifies specific hardware components causing failure for a given PC and Game.
% ------------------------------------------------------------------------------
bottleneck(PCName, Game, cpu_too_weak) :-
    \+ can_run_cpu(PCName, Game).

bottleneck(PCName, Game, insufficient_ram) :-
    \+ can_run_ram(PCName, Game).

bottleneck(PCName, Game, gpu_too_weak) :-
    \+ can_run_gpu(PCName, Game).

bottleneck(PCName, Game, ssd_required) :-
    \+ can_run_storage(PCName, Game).

% ==============================================================================
% 4. VS CODE EXTENSION DEBUGGER STUB
% ==============================================================================
start :- true.