; A1 Mini Optimized Start Routine
; Faster, safer and quieter drop-in start G-code.

; =====================================================
; ===== Machine: A1 Mini ==============================
; ===== Version: 1.0.0 ================================
; ===== Date: October 19, 2026 ========================
; ===== Based on: A1 Mini routine 1.4.2 ===============
; ===== by Cameron Condry, Cascade Media LLC ==========
; ===== github.com/cameroncondry/a1-mini-gcode ========
; ===== Bambu stock reference: 20260513 ===============
; =====================================================

; ===== warm-up =======================================
M1002 gcode_claim_action : 2            ; status: heatbed preheating
M1002 set_filament_type:{filament_type[initial_no_support_extruder]}

; preheat without waiting, bed +5C for heat soak (max 80C)
M104 S140                               ; nozzle probing temp
M140 S{min(bed_temperature_initial_layer_single + 5, 80)}

G392 S0                                 ; clog detect off
M9833.2                                 ; bambu: noise params

; ===== start sound ===================================
M17                                     ; motors on for sound
M400 S1                                 ; wait 1 s
M1006 S1                                ; speaker on
M1006 A0 B0 L70 C60 D10 M100 E60 F10 N100   ; C5
M1006 A0 B0 L85 C57 D10 M100 E57 F10 N100   ; A4
M1006 A0 B0 L70 C60 D10 M100 E60 F10 N100   ; C5
M1006 A0 B0 L85 C57 D10 M100 E57 F10 N100   ; A4
M1006 A0 B10 L30 C0 D10 M100 E0 F10 N100    ; short rest
M1006 A0 B0 L75 C67 D10 M100 E67 F10 N100   ; G5
M1006 A0 B0 L90 C64 D10 M100 E64 F10 N100   ; E5
M1006 A0 B0 L75 C67 D10 M100 E67 F10 N100   ; G5
M1006 A0 B0 L140 C64 D10 M100 E64 F10 N100  ; E5
M1006 W                                 ; wait for sound to finish
M18                                     ; motors off to reset

; ===== initialize printer state ======================
G90                                     ; absolute positioning
M83                                     ; relative extrusion
M211 X1 Y1 Z1                           ; soft endstops on
M630 S0 P0                              ; bambu: reset internal state

M204 S6000                              ; default acceleration
M17 X0.7 Y0.9 Z0.3                      ; motor currents, low Z for recovery

; camera light on for timelapse, otherwise keep the user setting
M622.1 S1                               ; default on for older firmware
M1002 judge_flag timelapse_record_flag
M622 J1
    M960 S5 P1                          ; camera light on
M623

M220 S100                               ; feedrate 100%
M221 S100                               ; flowrate 100%

M982.2 S1                               ; cog noise reduction on
M975 S1                                 ; vibration suppression on
M106 P1 S0                              ; part fan off
M73.2 R1.0                              ; reset time left

; ===== safe axis recovery ============================
M1002 gcode_claim_action : 13           ; status: homing toolhead
M17                                     ; motors on
G91                                     ; relative positioning
G380 S2 Z10 F1200                       ; guarded Z up
G380 S3 Z-6 F1200                       ; guarded Z down
G1 Z4 F1200                             ; clearance
G90                                     ; absolute positioning
M400

; ===== home axes =====================================
G28 X                                   ; home X and Y
G1 X50 Y175 F6000                       ; move to Z homing spot
G28 Z P0 T140                           ; home Z, low precision
M17 Z0.5                                ; restore Z current
M400

; ===== soft endstops off for service area ============
M211 S                                  ; save soft endstop state
M211 X0 Y0 Z0                           ; soft endstops off

; ===== build plate detection (flagged) ===============
M1002 judge_flag build_plate_detect_flag
M622 S1
    G39.4                               ; bambu: detect build plate
    G90                                 ; absolute positioning
    G1 Z5 F1200                         ; clearance
    M400
M623

; first wipe, removes loose residue
G1 Z5 F3000                             ; clearance
G1 X0 F12000                            ; wiper edge
G1 X-13.5 F3000                         ; into wiper
G1 X0 F24000                            ; wiper edge
G1 X-13.5 F3000                         ; second wipe, stay in wiper
M400

; ===== load filament (AMS) ===========================
M620 M                                  ; enable remap
M620 S[initial_no_support_extruder]A    ; AMS only: switch filament
    G392 S1                             ; clog detect on
    M1002 gcode_claim_action : 4        ; status: changing filament
    M400
    M1002 set_filament_type:UNKNOWN
    M109 S[nozzle_temperature_initial_layer] ; wait for print temp
    M104 S250                           ; common flush temp
    M400
    T[initial_no_support_extruder]      ; load filament
    G1 X-13.5 F3000                     ; into wiper
    M400
    M620.1 E F{flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60} T{flush_temperatures[initial_no_support_extruder]}
    M109 S250                           ; wait for flush temp
    M106 P1 S0                          ; part fan off
    G92 E0
    G1 E50 F200                         ; purge
    M400
    M1002 set_filament_type:{filament_type[initial_no_support_extruder]}
    M109 S{flush_temperatures[initial_no_support_extruder]} H300 ; wait for flush temp
    G92 E0
    G1 E50 F200                         ; second purge, slow against clogs
    M400
    M106 P1 S178                        ; part fan on
    G92 E0
    G1 E5 F200                          ; final purge
    ; drop nozzle temp to shrink the filament
    M109 S{nozzle_temperature_initial_layer[initial_no_support_extruder]-20}
    M104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]-40}
    G92 E0
    G1 E-0.5 F300                       ; retract

    ; wipe twice
    G1 X0 F12000
    G1 X-13.5 F3000
    G1 X0 F24000
    G1 X-13.5 F3000
    M400
    M106 P1 S0                          ; part fan off

    M104 S140                           ; nozzle probing temp
    G392 S0                             ; clog detect off
M621 S[initial_no_support_extruder]A

; ===== vibration compensation (disabled) =============
; skips the resonance tune and belt tension check before
; each print, so no HMS belt warning. To enable, remove
; the leading ";" from the lines below.
;M1002 gcode_claim_action : 3            ; status: vibration compensation
;G1 Z5 F3000                             ; clearance
;G1 X90 Y-1 F30000                       ; test position
;M400 P200                               ; wait 200 ms
;M970.3 Q1 A7 K0 O2                      ; bambu: fast resonance sweep
;M974 Q1 S2 P0                           ; bambu: fit result
;G1 X90 Y0 Z5 F30000                     ; test position
;M400 P200                               ; wait 200 ms
;M970 Q0 A10 B50 C90 H15 K0 M20 O3       ; bambu: resonance sweep
;M974 Q0 S2 P0                           ; bambu: fit result
;M975 S1                                 ; vibration suppression on
;G1 F30000
;G1 X-1 Y10                              ; move before re-home
;G28 X                                   ; home X and Y

; ===== clean nozzle ==================================
; previous material unknown, 170C softens most materials
M1002 gcode_claim_action : 7            ; status: heating nozzle
M109 S170                               ; cleaning temp

M1002 gcode_claim_action : 14           ; status: cleaning nozzle
M106 P1 S255                            ; fan blast to break strands
G4 P3000                                ; wait 3 s
M106 P1 S0                              ; part fan off

G90                                     ; absolute positioning
M83                                     ; relative extrusion

; knock off ooze with gentle taps
G1 Z5 F3000                             ; clearance
G1 E-1.0 F1200                          ; retract before taps
G1 X90 Y-4 F12000                       ; move to tap area
G380 S3 Z-1 F1200                       ; tap 1
G1 Z2 F3000                             ; lift
G1 X91 F6000                            ; step right
G380 S3 Z-1 F1200                       ; tap 2
G1 Z2 F3000
G1 X92 F6000
G380 S3 Z-1 F1200                       ; tap 3
G1 Z2 F3000
G1 X93 F6000
G380 S3 Z-1 F1200                       ; tap 4
G1 Z2 F3000
G1 X94 F6000
G380 S3 Z-1 F1200                       ; tap 5
G1 Z2 F3000
G380 S3 Z-1 F1200                       ; tap 6
G1 Z2 F3000
G380 S3 Z-1 F1200                       ; tap 7

; brush nozzle on silicone brush
G1 Z5 F3000                             ; clearance
G1 X25 Y175 F12000                      ; in front of brush
G1 Z0.2 F1200                           ; brush height
G1 Y185 F6000                           ; into brush
G91                                     ; relative positioning
G1 X-35 F24000                          ; brush pattern
G1 Y-2
G1 X32
G1 Y1.5
G1 X-33
G1 Y-2
G1 X35
G1 Y1.5
G1 X-35
G90                                     ; absolute positioning

; brush again, offset
G1 Z5 F3000                             ; clearance
G1 X25 Y176 F12000                      ; in front of brush, offset
G1 Z0.3 F1200                           ; brush height, offset
G1 Y186 F6000                           ; into brush, offset
G91                                     ; relative positioning
G1 X-35 F24000                          ; brush pattern
G1 Y-2
G1 X32
G1 Y1.5
G1 X-33
G1 Y-2
G1 X35
G1 Y1.5
G1 X-35
G90                                     ; absolute positioning

; final wipe with fan blast
G1 Z5 F3000                             ; clearance
G1 X0 F12000                            ; wiper edge
G1 X-13.5 F3000                         ; into wiper
M106 P1 S255                            ; fan blast
G4 P3000                                ; wait 3 s
G1 X0 F24000                            ; wiper edge
G1 X-13.5 F3000                         ; second wipe
M106 P1 S0                              ; part fan off
M400

; ===== restore protections ===========================
M211 R                                  ; restore soft endstop state
G29.2 S0                                ; mesh off for raw Z

; ===== park and heat bed =============================
M1002 gcode_claim_action : 2            ; status: heatbed preheating
M104 S140                               ; nozzle probing temp
M190 S[bed_temperature_initial_layer_single] ; wait for bed
M109 S140                               ; wait for nozzle
M400

; ===== bed leveling (flagged) ========================
M1002 judge_flag g29_before_print_flag
M622 J1
    M1002 gcode_claim_action : 1        ; status: bed leveling
    G29 A1 X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}
    M400
    M500                                ; save mesh
M623

M1002 judge_flag g29_before_print_flag
M622 J0
    M1002 gcode_claim_action : 13       ; status: homing toolhead
    G28 T300                            ; home all axes
M623

G29.2 S1                                ; mesh on

; ===== heat nozzle to print temp =====================
M1002 gcode_claim_action : 7            ; status: heating nozzle
M975 S1                                 ; vibration suppression on
G90                                     ; absolute positioning
M83                                     ; relative extrusion
T1000                                   ; bambu: select tool

M211 S                                  ; save soft endstop state
M211 X0 Y0 Z0                           ; soft endstops off
G1 Z5 F3000                             ; clearance
G1 X0 Y0 F12000                         ; wiper edge
G1 X-13.5 F3000                         ; into wiper

M109 S{nozzle_temperature_initial_layer[initial_extruder]} ; wait for print temp

; ===== prepare sensors ===============================
M1002 set_filament_type:UNKNOWN         ; reset filament type
M412 S1                                 ; runout detect on
M620.3 W1                               ; tangle detect on
G392 S0                                 ; clog detect off during calibration
M400 S2                                 ; wait 2 s
M1002 set_filament_type:{filament_type[initial_no_support_extruder]}

; prime nozzle in wiper
G92 E0
G1 E1.2 F500                            ; prime
G1 E-0.35 F1200                         ; micro retract

; ===== dynamic flow calibration (flagged) ============
M1002 judge_flag extrude_cali_flag
M622 J1
    M1002 gcode_claim_action : 8        ; status: flow calibration
    M900 K0.0 L1000.0 M1.0              ; pressure advance baseline
    G90                                 ; absolute positioning
    M83                                 ; relative extrusion
    G1 X-13.5 F3000                     ; into wiper
    M400

    ; measure flow dynamics
    G1 E10 F{outer_wall_volumetric_speed/2.4*60}
    M983 F{outer_wall_volumetric_speed/2.4} A0.3 H[nozzle_diameter]
    M106 P1 S255                        ; fan to break strand
    M400 S5                             ; wait 5 s

    ; wipe twice
    G1 X0 F12000
    G1 X-13.5 F3000
    G1 X0 F24000
    G1 X-13.5 F3000
    M400
    M106 P1 S0                          ; part fan off

    ; retry once on failure
    M1002 judge_last_extrude_cali_success
    M622 J0
        M983 F{outer_wall_volumetric_speed/2.4} A0.3 H[nozzle_diameter]
        M106 P1 S255                    ; fan to break strand
        M400 S5                         ; wait 5 s
        ; wipe twice
        G1 X0 F24000
        G1 X-13.5 F3000
        G1 X0 F24000
        G1 X-13.5 F3000
        M400
        M106 P1 S0                      ; part fan off
    M623

    ; final correction
    G1 X-13.5 F3000                     ; into wiper
    M400
    M984 A0.1 E1 S1 F{outer_wall_volumetric_speed/2.4} H[nozzle_diameter]
    M106 P1 S180                        ; fan to break strand
    M400 S7                             ; wait 7 s
    ; wipe twice
    G1 X0 F24000
    G1 X-13.5 F3000
    G1 X0 F24000
    G1 X-13.5 F3000
    M400
    M106 P1 S0                          ; part fan off
M623

; ===== calibration line ==============================
; hold first layer temps
M140 S{bed_temperature_initial_layer_single}
M109 S{nozzle_temperature_initial_layer[initial_extruder]}
M190 S{bed_temperature_initial_layer_single}

G90                                     ; absolute positioning
M83                                     ; relative extrusion

; clear ooze before the line
M106 P1 S255                            ; fan blast
G4 P2000                                ; wait 2 s
G1 E-0.05 F1200                         ; tiny retract
; wipe twice
G1 X0 F12000
G1 X-13.5 F3000
G1 X0 F24000
G1 X-13.5 F3000
M400
M106 P1 S0                              ; part fan off

; draw calibration line
G1 Z5 F3000                             ; clearance
G1 X68 Y-2.4 F24000                     ; line start
G1 Z0.3 F1200                           ; line height
G90                                     ; absolute positioning
M83                                     ; relative extrusion
M109 S{nozzle_temperature_initial_layer[initial_extruder]} ; wait for print temp
G1 X88 E10 F{outer_wall_volumetric_speed/(24/20)*60}
G1 X93 E0.3742 F{outer_wall_volumetric_speed/(0.3*0.5)/4*60}
G1 X98 E0.3742 F{outer_wall_volumetric_speed/(0.3*0.5)*60}
G1 X103 E0.3742 F{outer_wall_volumetric_speed/(0.3*0.5)/4*60}
G1 X108 E0.3742 F{outer_wall_volumetric_speed/(0.3*0.5)*60}
G1 X113 E0.3742 F{outer_wall_volumetric_speed/(0.3*0.5)/4*60}
G91                                     ; relative positioning
G1 X1 Z-0.3                             ; detach line
G1 X4
G1 Z1 F1200                             ; lift
G90                                     ; absolute positioning
M400

; second calibration line (flagged)
M1002 judge_flag extrude_cali_flag
M622 J1
    G90                                 ; absolute positioning
    G1 X68 Y-4.2 F24000                 ; line start
    G91                                 ; relative positioning
    G1 Z-0.7 F1200                      ; line height
    G90                                 ; absolute positioning
    M83                                 ; relative extrusion
    G1 X88 E10 F{outer_wall_volumetric_speed/(24/20)*60}
    G1 X93 E0.3742 F{outer_wall_volumetric_speed/(0.3*0.5)/4*60}
    G1 X98 E0.3742 F{outer_wall_volumetric_speed/(0.3*0.5)*60}
    G1 X103 E0.3742 F{outer_wall_volumetric_speed/(0.3*0.5)/4*60}
    G1 X108 E0.3742 F{outer_wall_volumetric_speed/(0.3*0.5)*60}
    G1 X113 E0.3742 F{outer_wall_volumetric_speed/(0.3*0.5)/4*60}
    G91                                 ; relative positioning
    G1 X1 Z-0.3                         ; detach line
    G1 X4
    G1 Z1 F1200                         ; lift
    G90                                 ; absolute positioning
    M400
M623

G1 Z0.2                                 ; hand-off height

; ===== part fan off ==================================
M106 P1 S0                              ; part fan off

; ===== final staging =================================
M1002 gcode_claim_action : 0            ; status: clear
; Bambu stock keeps clog detect off, comment out the next line to match
G392 S1                                 ; clog detect on
M975 S1                                 ; vibration suppression on
G90                                     ; absolute positioning
M83                                     ; relative extrusion
M211 R                                  ; restore soft endstop state
M211 X0 Y0 Z0                           ; soft endstops off for AMS moves
T1000                                   ; bambu: select tool
M1007 S1                                ; mass estimation on

; ===== textured PEI plate ============================
{if curr_bed_type=="Textured PEI Plate"}
    G29.1 Z{-0.02}                      ; Z offset -0.02 mm
{endif}

; ===== hand-off to slicer ============================
