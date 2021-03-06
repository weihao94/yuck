package yuck.core

import yuck.flatzinc.compiler.VariableWithInfiniteDomainException

/**
 * Implements typed variables.
 *
 * @author Michael Marte
 */
final class Variable
    [Value <: AnyValue]
    (id: Id[AnyVariable], name: String, private var currentDomain: Domain[Value])
    extends AnyVariable(id, name)
{

    /**
     * Replaces the variable's domain with the given domain.
     *
     * Throws when the new domain is not a subset of the current domain.
     */
    def pruneDomain(newDomain: Domain[Value]) {
        if (newDomain != currentDomain) {
            require(
                newDomain.isSubsetOf(currentDomain),
                "%s is not a subset of %s".format(newDomain, currentDomain))
            currentDomain = newDomain
        }
    }

    private var channelDomain: Domain[Value] = null

    /** Turns the variable into a channel that allow for the given values. */
    def turnIntoChannel(channelDomain: Domain[Value]) {
        require(currentDomain.isSubsetOf(channelDomain))
        this.channelDomain = channelDomain
    }

    /** Throws when the given value must not be assigned to the variable. */
    def checkAssignment(a: Value) {
        if (channelDomain == null) {
            require(
                currentDomain.contains(a),
                "Domain %s of variable %s does not contain value %s".format(currentDomain, this, a))
        } else {
            require(
                channelDomain.contains(a),
                "Channel domain %s of variable %s does not contain value %s".format(channelDomain, this, a))
        }
    }

    override def domain: Domain[Value] = currentDomain

    override def nextMove(space: Space, randomGenerator: RandomGenerator) =
        new ChangeValue(
            space.moveIdFactory.nextId,
            this,
            domain.nextRandomValue(randomGenerator, space.searchState.value(this)))

    override def assignRandomValue(space: Space, randomGenerator: RandomGenerator) = {
        space.setValue(this, domain.randomValue(randomGenerator))
    }

    private val reuseableEffect = new ReusableEffectWithFixedVariable[Value](this)

    override def nextRandomEffect(space: Space, randomGenerator: RandomGenerator) = {
        reuseableEffect.setNextRandomValue(space.searchState, randomGenerator)
        reuseableEffect
    }

}
