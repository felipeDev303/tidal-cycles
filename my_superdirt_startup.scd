module BootTidal where

import Sound.Tidal.Context

-- Configuración de conexión a SuperDirt
superDirtHost :: String
superDirtHost = "127.0.0.1"  -- Dirección IP de SuperDirt

superDirtPort :: Int
superDirtPort = 57120  -- Puerto de SuperDirt

-- Inicialización de TidalCycles
tidalConfig :: Config
tidalConfig = defaultConfig {
    cFrameTimespan = 1/20,  -- Tiempo de cada frame
    cLatency = 0.1,         -- Latencia
    cSchedule = schedule,    -- Función de programación
    cSuperDirt = (superDirtHost, superDirtPort)  -- Conexión a SuperDirt
}

-- Función principal para iniciar TidalCycles
main :: IO ()
main = do
    -- Iniciar el contexto de Tidal
    tidal <- startTidal tidalConfig
    putStrLn "TidalCycles iniciado y conectado a SuperDirt."