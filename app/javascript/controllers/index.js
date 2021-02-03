import { Application } from 'stimulus'
import { definitionsFromContext } from 'stimulus/webpack-helpers'
import StimulusReflex from 'stimulus_reflex'
import consumer from '../channels/consumer'

import ocl_tools from 'ocl_tools'

const application = Application.start()
const context = require.context('controllers', true, /_controller\.js$/)

const ocl_tools_controllers = Object.keys(ocl_tools.controllers).map((label) => (
  {'identifier': label, 'controllerConstructor': ocl_tools.controllers[label] }
))

const context_list = definitionsFromContext(context).concat(ocl_tools_controllers)

application.load(context_list)
StimulusReflex.initialize(application, { consumer })
