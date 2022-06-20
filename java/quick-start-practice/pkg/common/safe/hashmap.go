/**
* Generated by mosn mecha
 */

package safe

import (
	"errors"
	"fmt"
	"sync"
)

// IntMap Used to store type mappings of string and uint64 and is thread safe.
// This is especially useful in protocol scenarios where string ID identifiers are used
type IntMap struct {
	table map[string]uint64 // id -> encoded stream id
	lock  sync.RWMutex      // protect table
}

func (m *IntMap) Get(key string) (val uint64, found bool) {

	m.lock.RLock()
	if len(m.table) <= 0 {
		m.lock.RUnlock() // release read lock.
		return 0, false
	}

	val, found = m.table[key]

	m.lock.RUnlock()
	return
}

func (m *IntMap) Put(key string, val uint64) (err error) {

	m.lock.Lock()
	if m.table == nil {
		m.table = make(map[string]uint64, 8)
	}

	if v, found := m.table[key]; found {
		m.lock.Unlock()
		return errors.New(fmt.Sprintf("val conflict, exist key %s, val %d, current %d", key, v, val))
	}

	m.table[key] = val
	m.lock.Unlock()
	return
}

func (m *IntMap) Remove(key string) (err error) {

	m.lock.Lock()
	if m.table != nil {
		delete(m.table, key)
	}

	m.lock.Unlock()
	return
}
