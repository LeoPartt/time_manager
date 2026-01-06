class Clock {
  final int? id;
  final DateTime? arrivalTs;
  final DateTime? departureTs;

  const Clock({
     this.id,
    required this.arrivalTs,
    this.departureTs,
  });

   bool get isClockedIn => arrivalTs != null && departureTs == null;
  
  // 🔹 Helper pour savoir si on a clocké OUT
  bool get isClockedOut => departureTs != null;

}
