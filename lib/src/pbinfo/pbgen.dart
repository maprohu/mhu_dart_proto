part of 'pbinfo.dart';


abstract class PbFr<M extends GeneratedMessage> with HasFr<M> {
  final DspReg? _disposers;

  PbFr({DspReg? disposers}) : _disposers = disposers;
}

extension PbiPbFrX<M extends GeneratedMessage> on PbFr<M> {
  FR fr$<F, FR extends Fr<F>>(
      FieldAccess<M, F, dynamic> access,
      FR Function(Fr<F> item, {DspReg? disposers}) wrap,
      ) {
    return wrap(
      access.frWarm(
        fv$,
        disposers: _disposers,
      ),
      disposers: _disposers,
    );
  }

  CachedFr<F, int, List<F>, FR> list$<F, FR extends Fr<F>>(
      RepeatedFieldAccess<M, F> access,
      FR Function(Fr<F> item, {DspReg? disposers}) wrap,
      ) {
    return CachedFr.list(
      fv: access.frWarm(
        fv$,
        disposers: _disposers,
      ),
      wrap: (item) => wrap(
        item,
        disposers: _disposers,
      ),
      disposers: _disposers,
    );
  }

  CachedFr<F, K, Map<K, F>, FR> map$<F, K, FR extends Fr<F>>(
      MapFieldAccess<M, K, F> access,
      FR Function(Fr<F> item, {DspReg? disposers}) wrap,
      ) {
    return CachedFr.map(
      fv: access.frWarm(
        fv$,
        disposers: _disposers,
      ),
      wrap: (item) => wrap(
        item,
        disposers: _disposers,
      ),
      disposers: _disposers,
    );
  }
}

Fr<F> bareFr<F>(Fr<F> fv, {DspReg? disposers}) => fv;

Fw<F> bareFw<F>(Fw<F> fv, {DspReg? disposers}) => fv;

FV bareFv<FV>(FV fv, {DspReg? disposers}) => fv;

abstract class PbFw<M extends GeneratedMessage> with HasFw<M> {
  final DspReg? _disposers;

  PbFw({DspReg? disposers}) : _disposers = disposers;
}

extension PbiPbFwX<M extends GeneratedMessage> on PbFw<M> {
  FR fw$<F, FR extends Fw<F>>(
      ScalarFieldAccess<M, F> access,
      FR Function(Fw<F> item, {DspReg? disposers}) wrap,
      ) {
    return wrap(
      access.fw(
        fv$,
        disposers: _disposers,
      ),
      disposers: _disposers,
    );
  }

  CachedFu<F, int, List<F>, FR> list$<F, FR extends Fw<F>>(
      RepeatedFieldAccess<M, F> access,
      FR Function(Fw<F> item, {DspReg? disposers}) wrap,
      ) {
    return CachedFu.list(
      fv: access.fuHot(
        fv$,
        disposers: _disposers,
      ),
      wrap: (item) => wrap(
        item,
        disposers: _disposers,
      ),
      disposers: _disposers,
    );
  }

  CachedFu<F, K, Map<K, F>, FR> map$<K, F, FR extends Fw<F>>(
      MapFieldAccess<M, K, F> access,
      FR Function(Fw<F> item, {DspReg? disposers}) wrap,
      ) {
    return CachedFu.map(
      fv: access.fuHot(
        fv$,
        disposers: _disposers,
      ),
      wrap: (item) => wrap(
        item,
        disposers: _disposers,
      ),
      disposers: _disposers,
    );
  }
}

abstract interface class PbWhich {
  int get tagNumber$;
}
