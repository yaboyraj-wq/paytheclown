--!strict
local E = require("../Config/Economy")
local Runtime = require("../Config/Runtime")
local Input = require("./InputRules")
export type Entry = {
	id: string,
	reason: string,
	player: number,
	time: number,
	delta: number,
	before: number,
	after: number,
}
export type Ledger = { balance: number, revision: number, audit: { Entry }, seen: { [string]: boolean } }
local JarLedger = {}
function JarLedger.new(balance: number): Ledger
	assert(Input.integer(balance) and balance >= 0 and balance <= E.MAX_JAR, "Invalid opening balance")
	return { balance = balance, revision = 0, audit = {}, seen = {} }
end
-- Synchronous mutation: callers must never yield between validation and this operation.
function JarLedger.change(
	jar: Ledger,
	delta: number,
	reason: string,
	id: string,
	player: number,
	now: number
): boolean
	if jar.seen[id] or not Input.integer(delta) or jar.balance + delta < 0 then
		return false
	end
	local before = jar.balance
	jar.balance = math.min(E.MAX_JAR, before + delta)
	jar.revision += 1
	jar.seen[id] = true
	table.insert(jar.audit, {
		id = id,
		reason = reason,
		player = player,
		time = now,
		delta = jar.balance - before,
		before = before,
		after = jar.balance,
	})
	if #jar.audit > Runtime.AUDIT_LIMIT then
		table.remove(jar.audit, 1)
	end
	return true
end
return JarLedger
