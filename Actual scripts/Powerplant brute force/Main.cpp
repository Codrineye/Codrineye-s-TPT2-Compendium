#include <fstream>
#include <cmath>
#include <string>
#include <cstring>

using namespace std;

ifstream in("Test.in");
ofstream out("Test.out");

#define e6 1000000;

/*
 * Power
 * Root = 1000
 * yellow battery = 875787.780762 power
 * yellow battery = +5% for every yellow battery count
 * red battery = 400000 power
 * red battery = 1 + 0.03 * producer * red battery count
 * blue battery = 123501000
 * blue battery = (1% * emitter) * blue batteries count
*/

/*
fluid pipe 10000L
coal chest 2019483.91737kg
coal boiler 300 steam = -1000 water -40 coal
steam turbine 1920 power = -4 steam
oil barrel 2373763.138 oil
oil furnace 1000 steam = -2000 water -200 oil
gas tank 4747526.276 gas
gas turbine 3264.32 power = -800 gas
gas turbine +2% for every fluid pipe, its use is irelevant
water turbine 1536 power = -200 water
solar pannel 1024 power
solat pannel 10% of power output if rain
wind turbine 0, 1024, 2048, 3072, 4096 power
wind turbine x8 power if hurricane

*/

struct powerplant_grid{
   string components = "solarPanel lavaGenerator waterTurbine windTurbine waterPump coalStorage coalFurnace yellowBattery pipe oilStorage oilFurnace redBattery steamTurbine gasStorage gasTurbine blueBattery plasmaPipe helium3Storage fusionReactor plasmaTurbine lavaPump uraniumStorage fissionReactor dysonGenerator";
   int dyson_effect;
   int count;
};


int main() {

   powerplant_grid overview;
   powerplant_grid powerplant[19][13];

   return 0;
}