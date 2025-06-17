def test_login_sql_injection():
    res = client.post("/login?user=admin'--&pass=123")
    assert "Logged in" in res
