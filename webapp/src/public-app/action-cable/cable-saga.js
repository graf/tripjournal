import { eventChannel } from 'redux-saga'
import { take, call, put, fork, takeEvery, cancel } from 'redux-saga/effects'
import CableManager from './cable-manager'
import cableActions from './cable-actions'

function connectToChannel(manager) {
  return eventChannel(emit => {
    manager.addListener(data => emit(data))

    return () => manager.disconnect()
  })
}

function* consumeData(channel) {
  // eslint-disable-next-line
  while (true) {
    const data = yield take(channel)
    yield put(cableActions.dataReceived(data))
  }
}

function* createCableConnection(tripId) {
  const manager = new CableManager({tripId})
  const channel = yield call(connectToChannel, manager)

  const consumeTask = yield fork(consumeData, channel)

  yield take(cableActions.terminate)
  yield cancel(consumeTask)

  channel.close()
}

function* connectSaga(action) {
  yield call(createCableConnection, action.payload)
}

export default function* cableSagas() {
  yield takeEvery(cableActions.connectTo, connectSaga)
}
