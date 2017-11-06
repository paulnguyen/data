

public aspect TracingAspect {
	private int callDepth;

	//pointcut traced() : !within(TracingAspect) && ( execution(public * SM*.*(..)) || execution(public * Test*.*(..)) ) ;
	pointcut traced() : !within(TracingAspect) && ( execution(* SM*.*(..)) || execution(* Test*.*(..)) ) ;

	before() : traced() {
		print("Before", thisJoinPoint);
		callDepth++;
	}

	after() : traced() {
		callDepth--;
		print("After", thisJoinPoint);
	}

	private void print(String prefix, Object message) {
		for (int i = 0; i < callDepth; i++) {
			System.out.print(" ");
		}
		System.out.println(prefix + ": " + message);
	}
}