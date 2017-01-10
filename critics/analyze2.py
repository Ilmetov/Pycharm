def initCritics():

    critics = []
    # make some critics

    return critics

critics = initCritics()
import importlib
import recommendations
from recommendations import critics
importlib.reload(recommendations)
recommendations.sim_distance(critics,'Lisa Rose','Gene Seymour')
