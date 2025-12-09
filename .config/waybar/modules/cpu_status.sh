#!/bin/bash

# --- 1. Ottieni l'Uso della CPU (Percentuale Istantanea) ---
# Ottiene l'uso complessivo istantaneo (100 - % idle)
CPU_USAGE_RAW=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
CPU_USAGE_INT=$(echo ${CPU_USAGE_RAW:-0} | awk '{printf "%.0f", $1}') 

# --- 2. Ottieni la Temperatura ---
TEMP_RAW=$(sensors | awk '/temp/ {print $2}' | tr -d '+' | head -n 1)
TEMP=${TEMP_RAW//°C/}
TEMP_NUM=$(echo ${TEMP:-0} | tr -d ',') 

# --- 3. Ottieni le Frequenze in GHz ---
MAX_FREQ_RAW=$(lscpu | grep 'CPU max MHz' | awk '{printf "%.2f", $4/1000}' | head -n 1)

CUR_FREQ_FILE="/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq"
if [ ! -f "$CUR_FREQ_FILE" ]; then
    CUR_FREQ_FILE="/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq"
fi

CUR_FREQ_KHZ=$(cat "$CUR_FREQ_FILE" 2>/dev/null)
CUR_FREQ_RAW=$(echo ${CUR_FREQ_KHZ:-0} | awk '{printf "%.2f", $1/1000000}')

AVG_FREQ=${CUR_FREQ_RAW:-0.00}
MAX_FREQ=${MAX_FREQ_RAW:-0.00}

# --- 4. Costruisci i Contenuti ---

# Contenuto della Barra (Format)
# Formato richiesto: Icona + Uso
FORMAT_CONTENT="󰍛 ${CPU_USAGE_INT}%"

# Contenuto del Tooltip
# Formato richiesto: {uso} - {temperatura} \n {frequenza media}/{frequenza massima}
TOOLTIP_CONTENT="${CPU_USAGE_INT}% - ${TEMP_NUM}°C\n${AVG_FREQ}GHz/${MAX_FREQ}GHz"

# Stampa l'oggetto JSON con ENTRAMBI i campi
echo "{\"text\": \"$FORMAT_CONTENT\", \"tooltip\": \"$TOOLTIP_CONTENT\"}"
