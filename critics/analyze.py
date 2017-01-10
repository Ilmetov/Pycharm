import importlib
import recommendations
from recommendations import critics
#importlib.reload(recommendations)
print(recommendations.sim_distance(recommendations.critics, 'Lisa Rose', 'Gene Seymour'))
